//
//  ViewController.m
//  ObjCAdmob
//
//  Created by Cong Le on 9/2/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = UIColor.systemBrownColor;
  
  //MARK: - Banner ad setup -
  // use Test Ad ID for now. This Id should be replace by your production Ad Unit Id located at
  // https://apps.admob.com/v2/apps/3097473147/adunits/list?pli=1
  self.banner.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
  
  self.banner.rootViewController = self;
  self.banner.adSize = kGADAdSizeBanner; // set the ad banner size
  [self.banner loadRequest:[GADRequest request]]; // load an ad
  
  self.banner.delegate = self;
  
  self.banner.hidden = YES; // hide the banner ad by default
  
  
  [self createInterstitialAd];
  
  [self createRewardedVideoAd];
}
#pragma mark - GADBannerViewDelegate -
/// Tells the delegate an ad request loaded an ad
- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  self.banner.hidden = NO; // show the banner ad if loading an ad is successful
  
  // animating the banner ad with fading in effect
  bannerView.alpha = 0;
  [UIView animateWithDuration:1.0 animations:^{
    bannerView.alpha = 1;
  }];
  NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed
- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
  self.banner.hidden = YES; // hide the banner ad if loading an ad is failed
  NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

#pragma mark - Helper methods for Interstitial ad -
- (IBAction)showInterstitialAd:(id)sender {
  if (self.interstitialAd) {
    [self.interstitialAd presentFromRootViewController:self];
    
    [self createInterstitialAd]; // load an interstitial ad whenever the button is clicked
    
  } else {
    NSLog(@"Interstitial Ad wasn't ready");
  }
}

/// By default, the interstitial ad only load once per request
-(void)createInterstitialAd {
  /// Resource: https://developers.google.com/admob/ios/interstitial
  GADRequest *request = [GADRequest request];
  [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910" // need change this test ID to production ID
                              request: request
                    completionHandler:^(GADInterstitialAd *ad, NSError *error) {
    if (error) {
      NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
      return;
    }
    self.interstitialAd = ad;
  }];
}

#pragma mark - Helper methods for Rewarded Video Ad -
- (IBAction)showRewardedVideoAd:(id)sender {
  if (self.rewardedAd) {
    [self.rewardedAd presentFromRootViewController:self
                          userDidEarnRewardHandler:^{
      self->score += 100;
      self.rewardLabel.text = [NSString stringWithFormat:@"%i", self->score];
    }];
  } else {
    NSLog(@"Rewarded Video Ad wasn't ready");
  }
}

/// By default, the Rewarded Video  ad only load once per request
/// Note: Loading Rewarded Video ad might take a bit long depend on internet signal
-(void)createRewardedVideoAd {
  /// Resource: https://developers.google.com/admob/ios/rewarded
  GADRequest *request = [GADRequest request];
  [GADRewardedAd loadWithAdUnitID:@"ca-app-pub-3940256099942544/1712485313"
                          request:request
                completionHandler:^(GADRewardedAd *ad, NSError *error) {
    if (error) {
      NSLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
      return;
    }
    self.rewardedAd = ad;
    
    self.rewardedAd.fullScreenContentDelegate = self;
  }];
}

#pragma mark - GADFullScreenContentDelegate - Rewarded Video Ad Delegate methods
/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
  NSLog(@"Rewarded Video Ad did fail to present full screen content.");
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  NSLog(@"Rewarded Video Ad did present full screen content.");
  
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  [self createRewardedVideoAd]; // pre-load an Rewarded Video Ad
  NSLog(@"Ad did dismiss full screen content.");
}

@end
