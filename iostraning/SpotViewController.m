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
    
    self.navigationItem.title = @"スポットリスト";
    
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
    // テーブルビューセル再利用の設定
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // autoreleaseの必要がないため、従来のcellがnilだった場合の例外を適用
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // venues_からそれぞれ、ジャンル名（responseNAME）、URL(responseURL)を抜き出す
    // この時点では、要素1の配列で構成される配列となっている
    NSArray *responseNAME = [venues_ valueForKeyPath:@"categories.name"];
    NSArray *responseURL = [venues_ valueForKeyPath:@"categories.icon.prefix"];
    
    // 配列を抜き出した結果（文字列）を格納した配列
    NSArray *arrNAME = @[];
    NSArray *arrURL = @[];
    
    //// responseNAMEのデータ取り出し処理
    // NSArrayが要素となっているNSArrayを分解して(=0番目の要素を取り出して)NSStringを抽出し、新しいNSArrayを生成
    for (NSArray *data in responseNAME) {
        if ([data count] == 0) {
            arrNAME = [arrNAME arrayByAddingObject:@"NODATA"];
        }else{
            arrNAME = [arrNAME arrayByAddingObject:[data objectAtIndex:0]];
        }
    }
    
    //// responseURLのデータ取り出し処理
    // NSArrayが要素となっているNSArrayを分解して(=0番目の要素を取り出して)NSStringを抽出し、新しいNSArrayを生成
    for (NSArray *data in responseURL) {
        if ([data count] == 0) {
            arrURL = [arrURL arrayByAddingObject:@"NODATA"];
        }else{
            arrURL = [arrURL arrayByAddingObject:[data objectAtIndex:0]];
        }
    }
    
    // セル中の文字サイズを文字列の幅に合わせる
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    NSArray *dataArray = [NSArray array];
    
    if (dataArray == nil) {
        NSLog(@"dataArray ERROR!");
    }else{
        for (int i = 0; i < limit ; i++) {
            NSDictionary *mdic = [NSDictionary dictionaryWithObjectsAndKeys:[arrNAME objectAtIndex:i]
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
    
    //// ソート方法を定義する
    //NSSortDescriptor *descriptor1=[[NSSortDescriptor alloc] initWithKey:@"GENRE" ascending:YES];
    NSSortDescriptor *descriptor2=[[NSSortDescriptor alloc] initWithKey:@"DISTANCE.intValue" ascending:YES];
    
    
    //NSArray *sortedArr = [dataArray sortedArrayUsingDescriptors:@[descriptor1]];
    NSArray *sortedArr = [dataArray sortedArrayUsingDescriptors:@[descriptor2]];
    
    NSString *cellVal = [[sortedArr objectAtIndex:indexPath.row] objectForKey:@"DISTANCE"];
    
    cell.textLabel.text = [[[[[sortedArr objectAtIndex:indexPath.row]objectForKey:@"SPOT"] stringByAppendingString:@" - "] stringByAppendingString:[NSString stringWithFormat:@"%@",cellVal]] stringByAppendingString:@"m"];
    
    cell.detailTextLabel.text = [[sortedArr objectAtIndex:indexPath.row]objectForKey:@"GENRE"];
    
    sendArr = sortedArr;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
#pragma mark - ACQIRING DATE
    
    //// 取得日を作成(JSONデータ取得のための日付文字列生成 書式：yyyymmdd)
    // 5日前の日付を生成
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:-5*24*60*60];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour ;
    comps = [calendar components:flags fromDate:now];
    // 5日前の日付の年・月・日をそれぞれNSIntegerに格納
    NSInteger year = comps.year;
    NSInteger month = comps.month;
    NSInteger day = comps.day;
    
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    
#pragma mark - GET JSON DATA FROM WEB
    //// APIからベニューリストを取得
    // 一度に取得する施設数を設定
    limit = 30;
    // URL文字列を作成
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&limit=%d&client_id=ICIWPLPZATTTPYV0YBSVB4AQCF2PVXUWKHS3ZT1BURV0PS02&client_secret=T5SEMJSHYURT5UGERXLZNCUGI1QZ1JJHWBYN2XLDWK3FQUFN&v=%04ld%02ld%02ld", latitude, longitude,limit,(long)year,(long)month,(long)day];
    // jsonデータを取得
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *response = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    // 取得文字列をエンコードし、jsonDataに保存
    NSData *jsonData = [response dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    
#pragma mark - PREPARE FOR DISPLAYING TABLE VIEW DATA
    //// JSONデータから距離、緯度、経度、ベニューの各データをプロパティに保存する
    if (jsonData == nil) {
        // jsonDataが空の場合はエラーなので、コンソールに表示する(そのまま処理すると落ちる)
        NSLog(@"jsonData ERROR!");
    }else{
        //jsonDataをNSJSONSerializationによりjsonDicに辞書形式で保存する（全ての値がkey:valueで保存される）
        NSDictionary *jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:jsonData
                                 options:kNilOptions
                                 error:&error];
        //jsonDicから「キーバリューコーディング(valueForKeyPathを使う)」により緯度(responseLAT)、経度(responseLNG)を抜き出す
        NSArray *responseLAT = [jsonDic valueForKeyPath:@"response.venues.location.lat"];
        NSArray *responseLNG = [jsonDic valueForKeyPath:@"response.venues.location.lng"];
        
        //// 距離の算出と格納
        // Bpointに距離が格納される
        // spotLATとspotLNGに緯度、経度が格納される
        CLLocation *Apoint = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        NSArray *Bpoint = @[];
        NSArray *spotLAT = @[];
        NSArray *spotLNG = @[];
        
        for (int i = 0;i<limit;i++)
        {
            CLLocation *B = [[CLLocation alloc] initWithLatitude:[[responseLAT objectAtIndex:i] doubleValue] longitude:[[responseLNG objectAtIndex:i] doubleValue]];
            // ApointとBの距離を算出し(distancecFromLocation)、Bpointに代入
            Bpoint = [Bpoint arrayByAddingObject:[NSNumber numberWithFloat:[Apoint distanceFromLocation:B]]];
            // response*** → spot*** へ配列の要素を取り出しつつ、doubleに変換して保存する
            spotLAT = [spotLAT arrayByAddingObject:[NSNumber numberWithFloat:[[responseLAT objectAtIndex:i] doubleValue]]];
            spotLNG = [spotLNG arrayByAddingObject:[NSNumber numberWithFloat:[[responseLNG objectAtIndex:i] doubleValue]]];
            
        }
        
        if (!error) {
            //// jsonDicの要素数が0の場合、エラーコードをログに出力
            if ([jsonDic count] == 0) {
                NSLog(@"don't access it as the index is out of bounds");
                return;
            }else{
                //// 取得エラーコードをNSLogに表示
                NSInteger errorCode = [[[jsonDic objectForKey:@"meta"] objectForKey:@"code"] integerValue];
                NSLog(@"errorCode = %ld", (long)errorCode);
                //// jsonDicのデータのうち、venuesキーで取得できるvalueをvenuesに代入し、venues_（こちらはMutableArray）にコピー
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
    //テーブルビューのdatasourceを再読み込みする
    [self.tableView reloadData];
}


@end
