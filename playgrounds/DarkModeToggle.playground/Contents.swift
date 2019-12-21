//
// Copy the following section into an Objective-C file called DarkMode.m
//

#import <UIKit/UIKit.h>

#if DEBUG

@interface UIApplication ()
+ (void) _setDebugUserInterfaceStyleOverride:(NSInteger)override;
@end

@implementation UIApplication (ToggleUserInterfaceStyle)

+ (void) toggleUserInterfaceStyle {

    static NSInteger override = 0;
    override = override == 1 ? 2 : 1;
    [UIApplication _setDebugUserInterfaceStyleOverride:override];
}

@end

#endif

//
// Copy the following part into DarkMode.h
//

#if DEBUG

#ifndef DarkMode_h_h
#define DarkMode_h_h

#import <UIKit/UIKit.h>

@interface UIApplication (ToggleUserInterfaceStyle)

+ (void) toggleUserInterfaceStyle;

@end

#endif /* DarkMode_h_h */

#endif

