# JBSSettings

`JBSSettings` is a simple class that makes storing application settings
to disk easy. The settings are stored in an SQLite3 database (of your
choosing).

Settings are `@property` fields on a subclass of the `JBSSettings` object.

## Why not NSUserDefaults?

When you retrieve a value from `NSUserDefaults` it is returned as an
immutable object. I have found this to be more than a little annoying.
I want my settings manager to be easy, not a chore.

`JBSSettings` allows you to decide when to save values to disk, and it
doesn't intefere with the mutability you've set forth in your class
definition.

Read through the example in the **Usage** section to see just how
easy `JBSSetings` is to use.

## Usage

Install via [CocoaPods](http://cocoapods.org/):

```bash
pod 'JBSSettings'
```

Import the public header:

```objc
#import <JBSSettings/JBSSettings.h>
```

Emulate the example:

```objc
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

```

# License
The [MIT license](http://jsumners.mit-license.org/).