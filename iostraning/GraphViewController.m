//
//  GraphViewController.m
//
//
//  Created by cappuccinext on 2014/07/13.
//
//

#import "GraphViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GraphViewController ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation GraphViewController

@synthesize pieChart = _pieChart;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //タイトル表示
    self.title = @"ジャンル別グラフ表示";
    ////グラデーション部分（アイコン表示部分）の作成
    // レイヤーの作成
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // レイヤーサイズをビューのサイズをそろえる
    gradient.frame = CGRectMake(0, 360, 320, 180);
    
    // 開始色と終了色を設定
    gradient.colors = @[
                        // 開始色
                        (id)[UIColor whiteColor].CGColor,
                        // 終了色
                        (id)[UIColor orangeColor].CGColor];
    
    // レイヤーを追加
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    ////現在地の取得処理の開始部分
    // 現在地取得開始
    locationManager_ = [[CLLocationManager alloc] init];
    [locationManager_ setDelegate:self];
    locationManager_.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager_.distanceFilter = 25.0f;//25m移動するごとに測位値を返却する
    [locationManager_ startUpdatingLocation];
    
    ////グラフ表示部分
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    for(int i = 0; i < 5; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%10];
        [_slices addObject:one];
    }
    
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setPieCenter:CGPointMake(146,146)];
    
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor redColor],
                       [UIColor orangeColor],
                       [UIColor greenColor],
                       [UIColor yellowColor],
                       [UIColor purpleColor],nil];
    
    //NSLog(@"slices = %@",_sliceColors);
    
}

- (void)viewDidUnload
{
    [self setPieChart:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChart reloadData];
}

// GPSの位置情報が更新されたら呼ばれる
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSError *error;
    // 緯度・経度取得
    
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:-5*24*60*60];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour ;
    comps = [calendar components:flags fromDate:now];
    
    NSInteger year = comps.year;
    NSInteger month = comps.month;
    NSInteger day = comps.day;
    
    
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    limit = 30;
    
    CLLocation *Apoint = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // APIからベニューリストを取得
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&limit=%d&client_id=ICIWPLPZATTTPYV0YBSVB4AQCF2PVXUWKHS3ZT1BURV0PS02&client_secret=T5SEMJSHYURT5UGERXLZNCUGI1QZ1JJHWBYN2XLDWK3FQUFN&v=%04ld%02ld%02ld", latitude, longitude,limit,(long)year,(long)month,(long)day];
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
        //距離をコンソールに表示する
        for (int i = 0;i<limit;i++)
        {
            CLLocation *B = [[CLLocation alloc] initWithLatitude:[[responseLAT objectAtIndex:i] doubleValue] longitude:[[responseLNG objectAtIndex:i] doubleValue]];
            Bpoint = [Bpoint arrayByAddingObject:[NSNumber numberWithFloat:[Apoint distanceFromLocation:B]]];
            
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
            }
        }else{
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        [self loadPieChart];
    }
}

- (void)loadPieChart
{
#pragma mark - processing JSON data
    NSArray *responseJSON = [venues_ valueForKeyPath:@"categories.name"];
    
    NSArray *responseURL = [venues_ valueForKeyPath:@"categories.icon.prefix"];
    //NSLog(@"%@",responseJSON);
    
    NSArray *arrNAME = @[];
    NSArray *arrURL = @[];
    
    //nsdictionaryを複数作る
    //nsarrayでまとめる。
    
    //NSArrayが要素となっているNSArrayを分解してNSStringを抽出し、新しいNSArrayを生成
    //JSONで入れ子になっている要素がグループになっている場合に、Stringで格納されていないため、この処理を行う必要が有る
    for (NSArray *data in responseJSON) {
        if ([data count] == 0) {
            arrNAME = [arrNAME arrayByAddingObject:@"NODATA"];
        }else{
            arrNAME = [arrNAME arrayByAddingObject:[data objectAtIndex:0]];
        }
    }
    
    //NSArrayが要素となっているNSArrayを分解してNSStringを抽出し、新しいNSArrayを生成
    for (NSArray *data in responseURL) {
        if ([data count] == 0) {
            arrURL = [arrURL arrayByAddingObject:@"NODATA"];
        }else{
            arrURL = [arrURL arrayByAddingObject:[data objectAtIndex:0]];
        }
    }
    //検証用のNSLog *************** データ確認用 ****************
    //NSLog(@"array = %@", arrURL);
    
    NSString *samplepath;
    NSArray *arrTYPE;
    NSArray *arrCATEGORY;
    
    arrTYPE = @[];
    arrCATEGORY = @[];
    
    int shop_c = 0;
    int food_c = 0;
    int other_c = 0;
    int test1 = 0;
    int test2 = 0;
    int test3 = 0;
    int test4 = 0;
    int test5 = 0;
    int test6 = 0;
    int test7 = 0;
    
    //4番目の区切りの内容（施設タイプ）を抜き出す
    for (int i = 0; i < limit ; i++){
        if ([[arrURL objectAtIndex:i] isEqual:@"NODATA"]) {
            arrTYPE = [arrTYPE arrayByAddingObject:@"NODATA"];
        }else{
            samplepath = [arrURL objectAtIndex:i];
            NSArray *temparr;
            temparr = [samplepath pathComponents];
            arrTYPE = [arrTYPE arrayByAddingObject:[temparr objectAtIndex:4]];
        }
    }
    //5番目の区切りの内容（施設詳細タイプ）を抜き出す
    for (int i = 0; i < limit ; i++){
        if ([[arrURL objectAtIndex:i] isEqual:@"NODATA"]) {
            arrCATEGORY = [arrCATEGORY arrayByAddingObject:@"NODATA"];
        }else{
            samplepath = [arrURL objectAtIndex:i];
            NSArray *temparr;
            temparr = [samplepath pathComponents];
            arrCATEGORY = [arrCATEGORY arrayByAddingObject:[temparr objectAtIndex:5]];
        }
    }
    
    
    for (int i= 0 ; i<limit; i++) {
        if ([[arrTYPE objectAtIndex:i]  isEqual: @"shops"]) {
            shop_c++;
        }else if ([[arrTYPE objectAtIndex:i]  isEqual: @"food"]){
            food_c++;
        }else{
            other_c++;
        }
    }
    //NSLog(@"shop %d,food %d,other %d",shop_c,food_c,other_c);
    
    NSArray *dataArray = [NSArray array];
    
    //dictinaryWithOptionsAndKeys
    for (int i = 0; i < limit ; i++) {
        NSDictionary *mdic = [NSDictionary dictionaryWithObjectsAndKeys:[arrNAME objectAtIndex:i]
                              ,@"GENRE"
                              ,[[venues_ objectAtIndex:i]objectForKey:@"name"]
                              ,@"SPOT"
                              ,[[venues_ objectAtIndex:i]objectForKey:@"id"]
                              ,@"ID"
                              ,[distance_ objectAtIndex:i]
                              ,@"DISTANCE"
                              ,[arrTYPE objectAtIndex:i]
                              ,@"TYPE"
                              ,[arrCATEGORY objectAtIndex:i]
                              ,@"CATEGORY"
                              , nil];
        dataArray = [dataArray arrayByAddingObject:mdic];
    }
    
    //NSLog(@"%@",dataArray);
#pragma mark - Draw Pie Chart
    [_slices replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:shop_c]];
    [_slices replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:food_c]];
    [_slices replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:other_c]];
    [_slices replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:rand()%10]];
    [_slices replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:rand()%10]];
    
    [self.pieChart reloadData];
    
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
