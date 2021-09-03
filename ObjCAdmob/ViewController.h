//
//  ViewController.h
//  ObjCAdmob
//
//  Created by Cong Le on 9/2/21.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController : UIViewController <GADBannerViewDelegate, GADFullScreenContentDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *banner;

@property (strong, nonatomic) GADInterstitialAd *interstitialAd;

- (IBAction)showInterstitialAd:(id)sender;

@property (strong, nonatomic) GADRewardedAd *rewardedAd;

- (IBAction)showRewardedVideoAd:(id)sender;


@end

