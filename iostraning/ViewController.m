//
//  ViewController.m
//  iostraning
//
//  Created by cappuccinext on 2014/07/10.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import "ViewController.h"
#import <iAd/iAd.h>

@interface ViewController ()<ADBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    BOOL _bannerIsVisible;
    //  バナー表示の準備が完了したため、バナーが表示されていなければバナーを表示する。
    if (!_bannerIsVisible)
    {
        [UIView
         //  フェードインのアニメーションを指定
         animateWithDuration:1.0              //  アニメーションの時間を秒単位で指定
         delay: 0.0                       //  アニメーション開始までの時間を秒単位で指定
         options:UIViewAnimationOptionCurveEaseIn //  アニメーションの推移速度カーブの指定
         animations:^{                     //  アニメーションで変化させるプロパティ値を指定
             [banner setAlpha:1.0f];
         }
         completion:nil];
        
        _bannerIsVisible = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    for (UIView *viewTmp in self.view.subviews) {
        if ([viewTmp isMemberOfClass:[ADBannerView class]]) {
            ((ADBannerView *)viewTmp).delegate = nil;
        }
    }
    [super viewWillDisappear:animated];
}

@end
