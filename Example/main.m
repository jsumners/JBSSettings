@import Foundation;
#import "JBSSettings.h"

@interface MySettings : JBSSettings
@property NSString *foo;
@property NSURL *bar;
@end

@implementation MySettings
@end

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    MySettings *settings = [MySettings sharedInstance];
    NSString *settingsFile = [NSString pathWithComponents:@[@"/tmp/mysettings.db"]];
    // Note: the file will be created if it doesn't already exist
    [settings setSettingsFilePath:settingsFile];
    
    // First we will set some values and commit them to the settings file
    [settings setFoo:@"foobar"];
    [settings setBar:[NSURL URLWithString:@"http://jrfom.com/"]];
    NSLog(@"foo = %@", [settings foo]);
    NSLog(@"bar = %@", [settings bar]);
    [settings save:nil]; // Must be called when you want to commit to disk
    
    // Now we will clear our in-memory properties...
    [settings setFoo:nil];
    [settings setBar:nil];
    NSLog(@"foo = %@", [settings foo]);
    NSLog(@"bar = %@", [settings bar]);
    
    // ... and then load them from disk
    [settings load:nil];
    NSLog(@"foo = %@", [settings foo]);
    NSLog(@"bar = %@", [settings bar]);
  }
    return 0;
}
