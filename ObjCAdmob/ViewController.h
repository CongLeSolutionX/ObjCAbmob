//
//  ViewController.h
//  ObjCAdmob
//
//  Created by Cong Le on 9/2/21.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController : UIViewController <GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *banner;


@end

