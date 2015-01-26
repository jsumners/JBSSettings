#import <objc/runtime.h>
#import <objc/Protocol.h>
#import <FMDB/FMDB.h>
#import "JBSSettings.h"
#import "MAObjCRuntime/MARTNSObject.h"
#import "MAObjCRuntime/RTProperty.h"

@interface JBSSettings () {}

- (void)createDB;
- (FMDatabase *)database;
- (BOOL)databaseExists;
- (NSString *)databaseName;
@end

@implementation JBSSettings

@synthesize settingsFilePath;

#pragma mark Local Methods

- (BOOL)load:(NSError *__autoreleasing *)anError {
  if (settingsFilePath == nil) {
    if (*anError) {
      *anError  = [NSError errorWithDomain:@"com.jrfom.JBSSettings"
                                      code:SETTINGS_FILE_NOT_FOUND
                                  userInfo:@{NSLocalizedDescriptionKey:
                                               @"settingsFileURL: is nil"}];
    }
    return NO;
  }
  
  FMDatabase *db = [self database];
  [db open];
  FMResultSet *settings = [db executeQuery:@"select * from settings"];
  
  while ([settings next]) {
    NSString *name = [settings stringForColumn:@"name"];
    NSString *value = [settings stringForColumn:@"value"];
    
    NSData *valueData = [[NSData alloc]
                         initWithBase64EncodedString:value
                         options:0];
    id obj = [NSUnarchiver unarchiveObjectWithData:valueData];
    [self setValue:obj forKey:name];
  }
  [db close];
  
  return YES;
}

- (BOOL)save:(NSError *__autoreleasing *)anError {
  if (settingsFilePath == nil) {
    if (*anError) {
      *anError = [NSError errorWithDomain:@"com.jrfom.JBSSettings"
                                     code:SETTINGS_FILE_NOT_FOUND
                                 userInfo:@{NSLocalizedDescriptionKey:
                                              @"settingsFileURL: is nil"}];
    }
    return NO;
  }
  
  FMDatabase *db = [self database];
  NSArray *properties = [[self rt_class] rt_properties];
  
  [db open];
  for (RTProperty *property in properties) {
    NSString *name = [property name];
    NSData *data = [NSArchiver archivedDataWithRootObject:
                    [self valueForKey:name]];
    NSString *value = [data base64EncodedStringWithOptions:0];
    NSString *type = [[property attributes] objectForKey:@"T"];
    
    NSRange range;
    range.location = 2;
    range.length = [type length] - 3;
    type = [type substringWithRange:range];
    
    [db
     executeUpdate:@"replace into settings (type, name, value) values(?, ?, ?)",
     type, name, value];
  }
  [db close];
  
  return YES;
}

- (void)setSettingsFilePath:(NSString *)aFilePath {
  settingsFilePath = aFilePath;
  
  if (![self databaseExists]) {
    [self createDB];
  }
}

#pragma mark Private Methods

- (void)createDB {
  NSFileManager *fm = [NSFileManager defaultManager];
  [fm removeItemAtPath:settingsFilePath error:nil]; // kinda don't care
  [fm createFileAtPath:settingsFilePath contents:nil attributes:nil];
  
  FMDatabase *db = [FMDatabase databaseWithPath:settingsFilePath];
  [db open];
  
  NSString *query =
  @"create table if not exists settings ('type' text, 'name' text primary key, 'value' text)";
  [db executeUpdate:query];
  
  query = @"create index if not exists tidx on settings (type)";
  [db executeUpdate:query];
  
  query = @"create index if not exists nidx on settings (name)";
  [db executeUpdate:query];
  
  [db close];
}

- (FMDatabase *)database {
  // Should not be called from validation or create methods
  if ([self databaseExists]) {
    return [FMDatabase databaseWithPath:settingsFilePath];
  }
  
  return nil;
}

- (BOOL)databaseExists {
  NSFileManager *fm = [NSFileManager defaultManager];
  BOOL result = [fm fileExistsAtPath:settingsFilePath];
  
  if (result) {
    FMDatabase *db = [FMDatabase databaseWithPath:settingsFilePath];
    [db open];
    
    NSString *query = @"select name from sqlite_master where type = 'table'";
    FMResultSet *results = [db executeQuery:query];
    result = [results next];
    
    [db close];
  }
  
  return result;
}

- (NSString *)databaseName {
  NSString *name;
  NSArray *components = [settingsFilePath pathComponents];
  NSString *last = [components lastObject];
  
  return ([last containsString:@"."]) ?
    [last componentsSeparatedByString:@"."][0] : name;
}

#pragma mark Singleton Methods

+ (id)sharedInstance {
  static JBSSettings *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  self = [super init];
  return (self) ? self : nil;
}

- (void)dealloc {
  // Don't do it
}

@end
