//
//  ViewController.h
//  iostraning
//
//  Created by cappuccinext on 2014/07/10.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController<ADBannerViewDelegate>{
    ADBannerView *adView;
    BOOL bannerIsVisible; // 広告表示状態のフラグ
}
@end

