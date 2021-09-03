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
  self.view.backgroundColor = UIColor.systemRedColor;
  
  //MARK: - Banner ad setup -
  // use Test Ad ID for now. This Id should be replace by your production Ad Unit Id located at
  // https://apps.admob.com/v2/apps/3097473147/adunits/list?pli=1
  self.banner.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
  
  self.banner.rootViewController = self;
  self.banner.adSize = kGADAdSizeBanner; // set the ad banner size
  [self.banner loadRequest:[GADRequest request]]; // load an ad
  
  self.banner.delegate = self;
  
  self.banner.hidden = YES; // hide the banner ad by default
  
  
  //MARK: - Interstitial ad setup -
  // By default, the interstitial ad only load once per request
  [self createInterstitialAd];
}
// MARK: - GADBannerViewDelegate 
/// Tells the delegate an ad request loaded an ad
- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  self.banner.hidden = NO; // show the banner ad if loading an ad is successful
 
  // animating the banner ad with fading in effect
  bannerView.alpha = 0;
  [UIView animateWithDuration:2.0 animations:^{
    bannerView.alpha = 1;
  }];
  NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed
- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
  self.banner.hidden = YES; // hide the banner ad if loading an ad is failed
  NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

// MARK: - Helper methods for Interstitial ad
- (IBAction)showAd:(id)sender {
  if (self.interstitialAd) {
    [self.interstitialAd presentFromRootViewController:self];
    
    [self createInterstitialAd]; // load an interstitial ad whenever the button is clicked
    
  } else {
    NSLog(@"Ad wasn't ready");
  }
}

-(void)createInterstitialAd {
  /// Resource: https://developers.google.com/admob/ios/interstitial
  GADRequest *request = [GADRequest request];
  [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"
                              request: request
                    completionHandler:^(GADInterstitialAd *ad, NSError *error) {
    if (error) {
      NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
      return;
    }
    self.interstitialAd = ad;
  }];
}

@end
