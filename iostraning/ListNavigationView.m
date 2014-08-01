//
//  ListNavigationView.m
//  iostraning
//
//  Created by cappuccinext on 2014/08/01.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import "ListNavigationView.h"

@interface ListNavigationView ()

@end

@implementation ListNavigationView

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
- (BOOL)shouldAutorotate
{
    //表示しているViewControllerにまかせる
    return [self.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    //表示しているViewControllerにまかせる
    return [self.visibleViewController supportedInterfaceOrientations];
}

//初期向き
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //表示しているViewControllerにまかせる
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

@end
