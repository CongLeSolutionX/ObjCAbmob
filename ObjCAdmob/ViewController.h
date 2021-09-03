//
//  ViewController.h
//  ObjCAdmob
//
//  Created by Cong Le on 9/2/21.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController : UIViewController {
  int score;
}

@property (weak, nonatomic) IBOutlet GADBannerView *banner;

@property (strong, nonatomic) GADInterstitialAd *interstitialAd;

- (IBAction)showInterstitialAd:(id)sender;


- (IBAction)showRewardedVideoAd:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@end

