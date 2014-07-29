//
//  SpecifiedViewController.m
//  iostraning
//
//  Created by cappuccinext on 2014/07/22.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import "SpecifiedViewController.h"

@interface SpecifiedViewController ()

@end

@implementation SpecifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[_detailArr description]);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_detailArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // テーブルビューセル再利用の設定
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // autoreleaseの必要がないため、従来のcellがnilだった場合の例外を適用
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // セル中の文字サイズを文字列の幅に合わせる
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    NSSortDescriptor *descriptor2=[[NSSortDescriptor alloc] initWithKey:@"DISTANCE.intValue" ascending:YES];
    
    NSArray *sortedArr = [_detailArr sortedArrayUsingDescriptors:@[descriptor2]];
    
    NSString *cellVal = [[sortedArr objectAtIndex:indexPath.row] objectForKey:@"DISTANCE"];
    
    cell.textLabel.text = [[[[[sortedArr objectAtIndex:indexPath.row]objectForKey:@"SPOT"] stringByAppendingString:@" - "] stringByAppendingString:[NSString stringWithFormat:@"%@",cellVal]] stringByAppendingString:@"m"];
    
    cell.detailTextLabel.text = [[sortedArr objectAtIndex:indexPath.row]objectForKey:@"GENRE"];
    
    return cell;
}

@end
