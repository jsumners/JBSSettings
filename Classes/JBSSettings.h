@import Foundation;

extern enum {
  SETTINGS_FILE_NOT_FOUND = 1
} JBSSettingsErrors;

@interface JBSSettings : NSObject {
}

/**
 *  You should set this directly after initializing your {@link JBSSettings}
 *  instance. This is the file where your application's settings will be
 *  stored. It should *not* be a string representation of a URL.
 *
 *  NOTE: the destination file should be a single name, or contain only one
 *        dot separator. For example, "/tmp/foo" and "/tmp/foo.bar" are valid
 *        whereas "/tmp/foo.bar.db" is not.
 */
@property (retain, nonatomic) NSString *settingsFilePath;

+ (id)sharedInstance;

/**
 *  Loads settings from the file defined by
 *  {@link JBSSettings#settingsFilePath} and sets them to respective properties
 *  on the instance.
 *
 *  @param {NSError} anError If an error occurred during loading, this instance
 *                           will be set to a new {@link NSError} object
 *
 *  @return YES on successful load, NO otherwise
 */
- (BOOL)load:(NSError **)anError;

/**
 *  Saves the properties on the instance to the file specified by
 *  {@link JBSSettings#settingsFileURL}.
 *
 *  @param {NSError} anError If an error occurred during save, this instance
 *                           will be set to a new {@link NSError} object
 *
 *  @return YES on successful save, NO otherwise
 */
- (BOOL)save:(NSError **)anError;

@end
