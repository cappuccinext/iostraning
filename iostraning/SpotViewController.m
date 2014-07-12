//
//  SpotViewController.m
//  iostraning
//
//  Created by cappuccinext on 2014/07/10.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import "SpotViewController.h"
#import "MapViewController.h"

@interface SpotViewController ()

@end

@implementation SpotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.title = @"テスト";
    dataMain = [[NSArray alloc] initWithObjects:@"その１",@"その２", nil];
    dataDetail = [[NSArray alloc] initWithObjects:@"ほげ１",@"ほげ２", nil];
    
    // 現在地取得開始
    locationManager_ = [[CLLocationManager alloc] init];
    [locationManager_ setDelegate:self];
    locationManager_.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager_.distanceFilter = 25.0f;//25m移動するごとに測位値を返却する
    [locationManager_ startUpdatingLocation];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [venues_ count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //autoreleaseの必要がないため、従来のcellがnilだった場合の例外を適用
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text = [dataMain objectAtIndex:indexPath.row];
    
    return cell;
    */
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //autoreleaseの必要がないため、従来のcellがnilだった場合の例外を適用
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    NSArray *responseNAME = [venues_ valueForKeyPath:@"categories.name"];
    NSArray *responseURL = [venues_ valueForKeyPath:@"categories.icon.prefix"];
    
    //NSLog(@"%@",responseURL);
    
    NSArray *array = @[];
    NSArray *arrURL = @[];
    
    //nsdictionaryを複数作る
    //nsarrayでまとめる。
    
    //NSArrayが要素となっているNSArrayを分解してNSStringを抽出し、新しいNSArrayを生成
    for (NSArray *data in responseNAME) {
        if ([data count] == 0) {
            array = [array arrayByAddingObject:@"NODATA"];
            //NSLog(@"NODATA");
        }else{
            array = [array arrayByAddingObject:[data objectAtIndex:0]];
            //NSLog(@"name = %@",[data objectAtIndex:0]);
        }
    }
    
    //NSArrayが要素となっているNSArrayを分解してNSStringを抽出し、新しいNSArrayを生成
    for (NSArray *data in responseURL) {
        if ([data count] == 0) {
            arrURL = [arrURL arrayByAddingObject:@"NODATA"];
            //NSLog(@"NODATA");
        }else{
            arrURL = [arrURL arrayByAddingObject:[data objectAtIndex:0]];
            //NSLog(@"name = %@",[data objectAtIndex:0]);
        }
    }
    
    //検証用のNSLog *************** データ確認用 ****************
    //NSLog(@"array = %@", arrURL);
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    
    NSArray *dataArray = [NSArray array];
    
    //dictinaryWithOptionsAndKeys
    if (dataArray == nil) {
        NSLog(@"ERROR!");
    }else{
    for (int i = 0; i < limit ; i++) {
        NSDictionary *mdic = [NSDictionary dictionaryWithObjectsAndKeys:[array objectAtIndex:i]
                              ,@"GENRE"
                              ,[[venues_ objectAtIndex:i]objectForKey:@"name"]
                              ,@"SPOT"
                              ,[[venues_ objectAtIndex:i]objectForKey:@"id"]
                              ,@"ID"
                              ,[distance_ objectAtIndex:i]
                              ,@"DISTANCE"
                              ,[lat_ objectAtIndex:i]
                              ,@"LATITUDE"
                              ,[lng_ objectAtIndex:i]
                              ,@"LONGITUDE"
                              , nil];
        dataArray = [dataArray arrayByAddingObject:mdic];
    }
    }
    
    //NSSortDescriptor *descriptor1=[[NSSortDescriptor alloc] initWithKey:@"GENRE" ascending:YES];
    
    NSSortDescriptor *descriptor2=[[NSSortDescriptor alloc] initWithKey:@"DISTANCE.intValue" ascending:YES];
    
    
    //NSArray *sortedArr = [dataArray sortedArrayUsingDescriptors:@[descriptor1]];
    NSArray *sortedArr = [dataArray sortedArrayUsingDescriptors:@[descriptor2]];
    
    NSString *cellVal = [[sortedArr objectAtIndex:indexPath.row] objectForKey:@"DISTANCE"];
    
    cell.textLabel.text = [[[[[sortedArr objectAtIndex:indexPath.row]objectForKey:@"SPOT"] stringByAppendingString:@" - "] stringByAppendingString:[NSString stringWithFormat:@"%@",cellVal]] stringByAppendingString:@"m"];
    
    cell.detailTextLabel.text = [[sortedArr objectAtIndex:indexPath.row]objectForKey:@"GENRE"];
    
    sendArr = sortedArr;
    /*
     NSMutableArray *sortedDist = [[sortedArr objectAtIndex:indexPath.row] objectForKey:@"DISTANCE"];
     NSLog(@"%@",[sortedDist description]);
     
     NSString *cellVal = [[sortedArr objectAtIndex:indexPath.row] objectForKey:@"DISTANCE"];
     
     cell.textLabel.text = [NSString stringWithFormat:@"%@",cellVal];
     */
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSLog(@"%d",(int)indexPath.row);
    
    //MapViewController *mvc;
    //mvc.string = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    //[mvc setString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    //地図(MapViewController)に遷移する
    //[self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"spotmap"] animated:YES];
    
    [self performSegueWithIdentifier:@"ToMap"
                              sender:[sendArr objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController *c = segue.destinationViewController;
    c.string = (NSString *)sender;
    c.mapDic = (NSDictionary *)sender;
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSError *error;
    // 緯度・経度取得
    
#pragma mark - aquire date
    
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:-5*24*60*60];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour ;
    comps = [calendar components:flags fromDate:now];
    
    NSInteger year = comps.year;
    NSInteger month = comps.month;
    NSInteger day = comps.day;
    
    //NSLog(@"%04ld%02ld%02ld",(long)year,(long)month,(long)day);
    
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    limit = 30;
    
    CLLocation *Apoint = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // APIからベニューリストを取得
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&limit=%d&client_id=ICIWPLPZATTTPYV0YBSVB4AQCF2PVXUWKHS3ZT1BURV0PS02&client_secret=T5SEMJSHYURT5UGERXLZNCUGI1QZ1JJHWBYN2XLDWK3FQUFN&v=%04ld%02ld%02ld", latitude, longitude,limit,(long)year,(long)month,(long)day];
    //NSLog(@"urlString = %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *response = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [response dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    
    if (jsonData == nil) {
        NSLog(@"ERROR!");
    }else{
        NSDictionary *jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:jsonData
                                 options:kNilOptions
                                 error:&error];
        
        NSArray *responseLAT = [jsonDic valueForKeyPath:@"response.venues.location.lat"];
        NSArray *responseLNG = [jsonDic valueForKeyPath:@"response.venues.location.lng"];
        //NSLog(@"%@,%@",[responseLAT description],[responseLNG description]);
        
        NSArray *Bpoint = @[];
        NSArray *spotLAT = @[];
        NSArray *spotLNG = @[];
        //距離をコンソールに表示する
        for (int i = 0;i<limit;i++)
        {
            CLLocation *B = [[CLLocation alloc] initWithLatitude:[[responseLAT objectAtIndex:i] doubleValue] longitude:[[responseLNG objectAtIndex:i] doubleValue]];
            Bpoint = [Bpoint arrayByAddingObject:[NSNumber numberWithFloat:[Apoint distanceFromLocation:B]]];
            spotLAT = [spotLAT arrayByAddingObject:[NSNumber numberWithFloat:[[responseLAT objectAtIndex:i] doubleValue]]];
            spotLNG = [spotLNG arrayByAddingObject:[NSNumber numberWithFloat:[[responseLNG objectAtIndex:i] doubleValue]]];
            
        }
        //NSLog(@"distance = %@",[Bpoint description]);
        
        if (!error) {
            // エラーコードをログに出力
            if ([jsonDic count] == 0) {
                NSLog(@"don't access it as the index is out of bounds");
                return;
            }else{
                NSInteger errorCode = [[[jsonDic objectForKey:@"meta"] objectForKey:@"code"] integerValue];
                NSLog(@"errorCode = %ld", (long)errorCode);
                
                // 結果取得
                NSArray *venues = [[jsonDic objectForKey:@"response"] objectForKey:@"venues"];
                venues_ = [venues mutableCopy];
                distance_ = [Bpoint mutableCopy];
                lat_ = [spotLAT mutableCopy];
                lng_ = [spotLNG mutableCopy];
            }
        }else{
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        
    }
    //TODO:データをロードするときのライフサイクルを整理すること
    [self.tableView reloadData];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
