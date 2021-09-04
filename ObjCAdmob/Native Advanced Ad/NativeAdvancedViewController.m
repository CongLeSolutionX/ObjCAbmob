//
//  SecondViewController.m
//  SecondViewController
//
//  Created by Cong Le on 9/3/21.
//

#import "NativeAdvancedViewController.h"

// Native Advanced ad unit ID for testing.
static NSString *const NativeAdvenacedTestAdUnit = @"ca-app-pub-3940256099942544/3986624511";

// Extension of NativeAdvancedViewController and conform to protocols
@interface NativeAdvancedViewController () <GADNativeAdLoaderDelegate, GADNativeAdDelegate, GADVideoControllerDelegate>

/// You must keep a strong reference to the GADAdLoader during the ad loading
/// process.
@property(nonatomic, strong) GADAdLoader *adLoader;

/// The native ad view that is being presented.
@property(nonatomic, strong) GADNativeAdView *nativeAdView;

/// The height constraint applied to the ad view, where necessary.
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@implementation NativeAdvancedViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = UIColor.systemGreenColor;
  
  [self setAdView:[[NSBundle mainBundle] loadNibNamed:@"NativeAdView" owner:nil options:nil]
   .firstObject];
  
  [self refreshAd: nil];
  
  self.versionLabel.text = GADMobileAds.sharedInstance.sdkVersion;
  
}
#pragma mark - Helper methods -
-(void)setAdView:(GADNativeAdView *) view {
  // Remove previous ad view
  [self.nativeAdView removeFromSuperview];
  self.nativeAdView = view;
  
  // Add new ad view and set constraints to fill its container.
  [self.nativeAdPlaceHolder addSubview:view];
  [self.nativeAdView setTranslatesAutoresizingMaskIntoConstraints:NO];
  
  NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_nativeAdView);
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nativeAdView]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDictionary]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nativeAdView]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDictionary]];
}
- (IBAction)refreshAd:(nullable)sender {
  // Prevent the user to switch button many times
  self.refreshButton.enabled = NO;
  
  // Default the video ad play in muted
  GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
  videoOptions.startMuted = self.startMutedSwitch.on;
  
  // Loads a native ad
  self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:NativeAdvenacedTestAdUnit
                                     rootViewController:self
                                                adTypes:@[kGADAdLoaderAdTypeNative]
                                                options:@[videoOptions]];
  
  self.adLoader.delegate = self;
  [self.adLoader loadRequest:[GADRequest request]];
  self.videoStatusLabel.text = @"";
  
}

#pragma mark -  GADAdLoaderDelegate implementation -

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull NSError *)error {
  NSLog(@"%@ failed with error: %@", adLoader, error);
  self.refreshButton.enabled = YES;
}
#pragma mark -  GADNativeAdLoaderDelegate implementation -

- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveNativeAd:(nonnull GADNativeAd *)nativeAd {
  self.refreshButton.enabled = YES;
  
  GADNativeAdView *nativeAdView = self.nativeAdView;
  
  // Deactivate the height constraint that was set when the previous video ad loaded.
  self.heightConstraint.active = NO;
  
  // Set ourselves as the ad delegate to be notified of native ad events.
  nativeAd.delegate = self;
  
  // Populate the native ad view with the native ad assets.
  // The headline and mediaContent are guaranteed to be present in every native ad.
  ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
  nativeAdView.mediaView.mediaContent = nativeAd.mediaContent;
  
  // This app uses a fixed width for the GADMediaView and changes its height
  // to match the aspect ratio of the media content it displays.
  if (nativeAd.mediaContent.aspectRatio > 0) {
    self.heightConstraint =
    [NSLayoutConstraint constraintWithItem:nativeAdView.mediaView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nativeAdView.mediaView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:(1 / nativeAd.mediaContent.aspectRatio)
                                  constant:0];
    self.heightConstraint.active = YES;
  }
  
  if (nativeAd.mediaContent.hasVideoContent) {
    // By acting as the delegate to the GADVideoController, this ViewController
    // receives messages about events in the video lifecycle.
    nativeAd.mediaContent.videoController.delegate = self;
    
    self.videoStatusLabel.text = @"Ad contains a video asset.";
  } else {
    self.videoStatusLabel.text = @"Ad does not contain a video.";
  }
  
  // These assets are not guaranteed to be present. Check that they are before
  // showing or hiding them.
  ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
  nativeAdView.bodyView.hidden = nativeAd.body ? NO : YES;
  
  [((UIButton *)nativeAdView.callToActionView) setTitle:nativeAd.callToAction
                                               forState:UIControlStateNormal];
  nativeAdView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;
  
  ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
  nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;
  
  //  ((UIImageView *)nativeAdView.starRatingView).image = [self imageForStars:nativeAd.starRating];
  //  nativeAdView.starRatingView.hidden = nativeAd.starRating ? NO : YES;
  
  ((UILabel *)nativeAdView.storeView).text = nativeAd.store;
  nativeAdView.storeView.hidden = nativeAd.store ? NO : YES;
  
  ((UILabel *)nativeAdView.priceView).text = nativeAd.price;
  nativeAdView.priceView.hidden = nativeAd.price ? NO : YES;
  
  ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
  nativeAdView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;
  
  // In order for the SDK to process touch events properly, user interaction
  // should be disabled.
  nativeAdView.callToActionView.userInteractionEnabled = NO;
  
  // Associate the native ad view with the native ad object. This is
  // required to make the ad clickable.
  // Note: this should always be done after populating the ad views.
  nativeAdView.nativeAd = nativeAd;
  
}

#pragma mark - GADVideoControllerDelegate implementation -

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
  self.videoStatusLabel.text = @"Video playback has ended.";
}
#pragma mark - GADNativeAdDelegate -

- (void)nativeAdDidRecordClick:(GADNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidRecordImpression:(GADNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillPresentScreen:(GADNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillDismissScreen:(GADNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidDismissScreen:(GADNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillLeaveApplication:(GADNativeAd *)nativeAd {
  NSLog(@"%s", __PRETTY_FUNCTION__);
}
@end
