//
//  AppDelegate.m
//  ObjCAdmob
//
//  Created by Cong Le on 9/2/21.
//
// Reference: https://guides.codepath.com/ios/Tab-Bar-Controller-Guide
#import "AppDelegate.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MixedAdsViewController.h"

@implementation AppDelegate
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
  
  
  //check if the 2nd viewcontroller eixsts, otherwise create it
  if(self.nativeAdvancedViewController == nil) {
    NativeAdvancedViewController *nativeAdvancedViewVC = [storyboard instantiateViewControllerWithIdentifier:@"NativeAdvancedViewController"];
    self.nativeAdvancedViewController = nativeAdvancedViewVC;
  }
  
  //check if the tab bar viewcontroller eixsts, otherwise create it
  if(self.tabBarController == nil) {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
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


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
