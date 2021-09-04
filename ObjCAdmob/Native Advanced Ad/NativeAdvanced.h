//
//  SecondViewController.h
//  SecondViewController
//
//  Created by Cong Le on 9/3/21.
//
/// Documentation: https://developers.google.com/admob/ios/native/advanced

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeAdvanced : UIViewController
@property (weak, nonatomic) IBOutlet UIView *nativeAdPlaceHolder;

@property (weak, nonatomic) IBOutlet UILabel *videoStatusLabel;

@property (weak, nonatomic) IBOutlet UISwitch *startMutedSwitch;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)refreshAd:(id)sender;

@end

NS_ASSUME_NONNULL_END
