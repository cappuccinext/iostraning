//
//  MyNavigationController.m
//  iostraning
//
//  Created by cappuccinext on 2014/08/01.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return [self.visibleViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return self.visibleViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

@end
