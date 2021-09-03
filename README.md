# ObjCAbmob
A demo app shows how to integrate Google AdMob in Objective-C 

## Steps to integrate Banner ad: 

1. Create a Google Admob account via this [site](https://admob.google.com/home/?gclid=Cj0KCQjw7MGJBhD-ARIsAMZ0eeucLf-48HPMilo0v5rRjU8UXn5drQSRU-GWmHuehL5QEV7AqPK8wioaAhDbEALw_wcB)

2. Create new app in Google Abmob dashboard and have App ID ready for next steps
The App ID should have a format as ca-app-pub-7123458538882040~3097412345

3. Create a banner ad and obtain the Ad Unit Id, which is use for production later.

4. Create a new objective-C project on XCode

5. Follow these [instructions](https://medium.com/@soufianerafik/how-to-add-pods-to-an-xcode-project-2994aa2abbf1) to install CocoaPods for your ObjC project

6. Follow instruction from [this documentration](https://developers.google.com/admob/ios/quick-start) to use CocoaPods to import Google Mobile Ads SDK

Note: Add the `-ObjC` linker flag to **Other Linker Flags** in your project's build settings

7. Create a UIView on storyboard and assign it as `GADBannerView` class. 

8. Add `GoogleMobileAds.xcframework` into **Link Binary With Libraries section** of the project target.
 
9. Update your **Info.plist** in XCode project via using the [documentation](https://developers.google.com/admob/ios/quick-start#update_your_infoplist)

10. Follow the instruction to implement Banner ad in [this guide](https://developers.google.com/admob/ios/banner). Conform **ViewController.h** to `GADBannerViewDelegate` as following: 

```swift
@interface ViewController : UIViewController <GADBannerViewDelegate>
```

11. Follow [these instructions](https://developers.google.com/admob/ios/banner#objective-c) to get the banner size and to impplement the banner.

12. Add the following code snippet into **ViewController.m**: 

```swift
  self.banner.adUnitID = @"ca-app-pub-3940256099942544/2934735716"; // use Test Ad ID
  self.banner.rootViewController = self;
  self.banner.adSize = kGADAdSizeBanner; // set the ad banner size
  [self.banner loadRequest:[GADRequest request]]; // load an ad
  
  self.banner.delegate = self;
  
  self.banner.hidden = YES; // hide the banner ad by default
  ```
  
13. Add the following `GADBannerViewDelegate` methods into **ViewController.m**:

```swift 
/// Tells the delegate an ad request loaded an ad
- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  self.banner.hidden = NO; // show the banner ad if loading an ad is successful
  NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed
- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
  self.banner.hidden = YES; // hide the banner ad if loading an ad is failed
  NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

```

14. You might face an error as **"The Google Mobile Ads SDK was initialized without AppMeasurement...."**. The reason is we imported **Google Mobile Ads SDK** via **CocoaPods** and indirectly importing **GoogleAppMeasurement SDK** but does not configure it properly. The fix is very easy: update you **Info.plist** in XCode with a new property `GADIsAdManagerApp` as Boolean with value as 1.


## Steps to integrate Interstitial ad: 

1. Use the current setup made for Banner app

2. Create an interstitial ad unit with ID for you App on the Google Admob dashboard. We will use its ID for production later.

3. Follow the instruction to implement interstitial ad in [this guide](https://developers.google.com/admob/ios/interstitial).

4. Create a **UIButton** on the storyboard and connect to the **ViewController.h**

5. Add the following methods to **ViewController.m**: 

```swift 
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
```

6. Call the following function in `viewDidLoad()` in **ViewController.m**

```swift
[self createInterstitialAd];
```

