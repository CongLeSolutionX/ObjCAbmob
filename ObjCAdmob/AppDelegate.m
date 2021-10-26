//
//  AppDelegate.m
//  ObjCAdmob
//
//  Created by Cong Le on 9/2/21.
//
#import "AppDelegate.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MixedAdsViewController.h"

@implementation AppDelegate
/// Reference of App Life Cycle events: https://medium.com/@neroxiao/ios-app-life-cycle-ec1b31cee9dc
// MARK: - Launch functions of app lifecycle
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions{
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize Google Mobile Ads SDK
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    
    // create UIWindow with the same size as main screen
    self.window = [[UIWindow alloc] initWithFrame: UIScreen.mainScreen.bounds];
    
    // create storyboard.
    // Default story board will be named as Main.storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // create view controllers from storyboard
    // make sure to set the storyboard  ID for each viewcontroller in
    // Interface Builder -> Identitiy Inspector -> Storyboard ID
    MixedAdsViewController *mixedAdsViewController = [storyboard instantiateViewControllerWithIdentifier: @"MixedAdsViewController"];
    
    
    //check if the 2nd viewcontroller exists, otherwise create it
    if(self.nativeAdvancedViewController == nil) {
        NativeAdvancedViewController *nativeAdvancedViewVC = [storyboard instantiateViewControllerWithIdentifier:@"NativeAdvancedViewController"];
        self.nativeAdvancedViewController = nativeAdvancedViewVC;
    }
    /// Reference: https://guides.codepath.com/ios/Tab-Bar-Controller-Guide
    //check if the tab bar viewcontroller exists, otherwise create it
    if(self.tabBarController == nil) {
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.tabBar.backgroundColor = UIColor.systemYellowColor;
        self.tabBarController = tabBarController;
    }
    
    self.tabBarController.viewControllers = @[mixedAdsViewController, self.nativeAdvancedViewController];
    
    mixedAdsViewController.tabBarItem.title = @"Mixed Ads View"; // dont use self. since this variable just created in this block
    self.nativeAdvancedViewController.tabBarItem.title = @"Native Advanced";
    
    // make the Tab Bar Controller the root view controller
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}
// MARK: - The app is in Running State
/// Activate the app
- (void)applicationDidBecomeActive:(UIApplication *)application {
}

// MARK: - Functions of Foreground State
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
/// Deactivate the app
- (void)applicationWillResignActive:(UIApplication *)application {
}
// MARK: - Functions of Background State
- (void)applicationDidEnterBackground:(UIApplication *)application {
}

// MARK: - Termination functions of app lifecycle
- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
