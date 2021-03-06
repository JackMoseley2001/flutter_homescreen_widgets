#import "HomescreenWidgetsPlugin.h"
#if __has_include(<homescreen_widgets/homescreen_widgets-Swift.h>)
#import <homescreen_widgets/homescreen_widgets-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "homescreen_widgets-Swift.h"
#endif

@implementation HomescreenWidgetsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHomescreenWidgetsPlugin registerWithRegistrar:registrar];
}
@end
