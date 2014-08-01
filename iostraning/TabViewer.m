//
//  TabViewer.m
//  iostraning
//
//  Created by cappuccinext on 2014/08/01.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import "TabViewer.h"

@interface TabViewer ()

@end

@implementation TabViewer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//回転させるかどうか
- (BOOL)shouldAutorotate
{
    //選択したViewController(navigationならnavigation)に任せる
    return YES;
}

//回転させる向きを指定
- (NSUInteger)supportedInterfaceOrientations
{
    //選択したViewController(navigationならnavigation)に任せる
    return [self.selectedViewController supportedInterfaceOrientations];
}

//初期向き
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //選択したViewController(navigationならnavigation)に任せる
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end
