#import "FlutterQiblahPlugin.h"
#if __has_include(<flutter_qiblah/flutter_qiblah-Swift.h>)
#import <flutter_qiblah/flutter_qiblah-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_qiblah-Swift.h"
#endif

@implementation FlutterQiblahPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterQiblahPlugin registerWithRegistrar:registrar];
}
@end
