//
//  AppDelegate.h
//  iostraning
//
//  Created by cappuccinext on 2014/07/10.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewController.h"
#import "SpotViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UITabBarController *tabBarController_;
}

@property (strong, nonatomic) UIWindow *window;

- (void)switchTabBarController:(NSInteger)selectedViewIndex;

@end

