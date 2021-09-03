//
//  ViewController.m
//  ObjCAdmob
//
//  Created by Cong Le on 9/2/21.
//

#import "ViewController.h"

#pragma mark - CONSTANTS -
// Replace these Test Ad IDs when deploy the app into production flow.
// Production IDs are all in this dashboard: https://apps.admob.com/v2/apps/3097473147/adunits/list?pli=1
static NSString *const BannerTestAdUnit = @"ca-app-pub-3940256099942544/2934735716";
static NSString *const InterstitialTestAdUnit = @"ca-app-pub-3940256099942544/4411468910";
static NSString *const RewardedTestAdUnit = @"ca-app-pub-3940256099942544/1712485313";

#pragma mark - Extension -
// Extension of ViewController and conform to protocol GADBannerViewDelegate
@interface ViewController() <GADBannerViewDelegate>

@end

// Extension of ViewController and conform to protocol GADFullScreenContentDelegate
@interface ViewController () <GADFullScreenContentDelegate>

@property (strong, nonatomic) GADRewardedAd *rewardedAd;

@end

#pragma mark - Implementation of View Controller -
@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = UIColor.systemBrownColor;
  
  //MARK: - Banner ad setup -
  self.banner.adUnitID = BannerTestAdUnit;
  
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
  NSLog(@"ad View Did Receive Banner Ad");
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
  [GADInterstitialAd loadWithAdUnitID:InterstitialTestAdUnit
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
  [GADRewardedAd loadWithAdUnitID:RewardedTestAdUnit
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
