//
//  AppDelegate.h
//  ObjCAdmob
//
//  Created by Cong Le on 9/2/21.
//

#import <UIKit/UIKit.h>
#import "NativeAdvancedViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) NativeAdvancedViewController *nativeAdvancedViewController;

@end

