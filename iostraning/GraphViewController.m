//
//  GraphViewController.m
//  
//
//  Created by cappuccinext on 2014/07/13.
//
//

#import "GraphViewController.h"
#import "ISRemoveNull.h"

@interface GraphViewController ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation GraphViewController

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
    
    self.title = @"Charts";
    
    // Chart View
    _chartView = [[TWRChartView alloc] initWithFrame:CGRectMake(0, 224, 320, 300)];
    _chartView.backgroundColor = [UIColor orangeColor];
    
    // User interaction is disabled by default. You can enable it again if you want
    //_chartView.userInteractionEnabled = YES;
    
    // レイヤーの作成
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // レイヤーサイズをビューのサイズをそろえる
    gradient.frame = CGRectMake(0, 0, 320, 224);
    
    // 開始色と終了色を設定
    gradient.colors = @[
                        // 開始色
                    (id)[UIColor whiteColor].CGColor,
                        // 終了色
                        (id)[UIColor orangeColor].CGColor];
    
    // レイヤーを追加
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // Load chart by using a ChartJS javascript file
    //NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"js"];
    //[_chartView setChartJsFilePath:jsFilePath];
    
    // Add the chart view to the controller's view

    
    
    [self.view addSubview:_chartView];
    
    // 現在地取得開始
    locationManager_ = [[CLLocationManager alloc] init];
    [locationManager_ setDelegate:self];
    locationManager_.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager_.distanceFilter = 25.0f;//25m移動するごとに測位値を返却する
    [locationManager_ startUpdatingLocation];
    
}

// GPSの位置情報が更新されたら呼ばれる
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSError *error;
    // 緯度・経度取得
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    limit = 30;
    
    CLLocation *Apoint = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // APIからベニューリストを取得
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&limit=%d&client_id=ICIWPLPZATTTPYV0YBSVB4AQCF2PVXUWKHS3ZT1BURV0PS02&client_secret=T5SEMJSHYURT5UGERXLZNCUGI1QZ1JJHWBYN2XLDWK3FQUFN&v=20140627", latitude, longitude,limit];
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
    
    NSArray *array = @[];
    NSArray *arrURL = @[];
    
    //nsdictionaryを複数作る
    //nsarrayでまとめる。
    
    //NSArrayが要素となっているNSArrayを分解してNSStringを抽出し、新しいNSArrayを生成
    //JSONで入れ子になっている要素がグループになっている場合に、Stringで格納されていないため、この処理を行う必要が有る
    for (NSArray *data in responseJSON) {
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
    NSLog(@"array = %@", arrURL);
    
    NSString *samplepath;
    NSArray *pathcomponents;
    
    pathcomponents = @[];
    
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

    
    
    //NODATAの場合はオブジェクトが存在しないので落ちる→NODATAの場合は適当なデータを埋め込む
    for (int i = 0; i < limit ; i++){
        if ([[arrURL objectAtIndex:i] isEqual:@"NODATA"]) {
            pathcomponents = [pathcomponents arrayByAddingObject:@"NODATA"];
        }else{
            samplepath = [arrURL objectAtIndex:i];
            NSArray *temparr;
            temparr = [samplepath pathComponents];
            NSLog(@"%@",[temparr objectAtIndex:4]);
            pathcomponents = [pathcomponents arrayByAddingObject:[temparr objectAtIndex:4]];
        }
    }
    //NSLog(@"%@",[pathcomponents description]);
    
    for (int i= 0 ; i<limit; i++) {
        if ([[pathcomponents objectAtIndex:i]  isEqual: @"shops"]) {
            shop_c++;
        }else if ([[pathcomponents objectAtIndex:i]  isEqual: @"food"]){
            food_c++;
        }else{
            other_c++;
        }
    }
    NSLog(@"shop %d,food %d,other %d",shop_c,food_c,other_c);
    
    NSArray *dataArray = [NSArray array];
    
    //dictinaryWithOptionsAndKeys
    for (int i = 0; i < limit ; i++) {
        NSDictionary *mdic = [NSDictionary dictionaryWithObjectsAndKeys:[array objectAtIndex:i]
                              ,@"GENRE"
                              ,[[venues_ objectAtIndex:i]objectForKey:@"name"]
                              ,@"SPOT"
                              ,[[venues_ objectAtIndex:i]objectForKey:@"id"]
                              ,@"ID"
                              ,[distance_ objectAtIndex:i]
                              ,@"DISTANCE"
                              , nil];
        dataArray = [dataArray arrayByAddingObject:mdic];
    }
    
    
    //NSSortDescriptor *descriptor1=[[NSSortDescriptor alloc] initWithKey:@"GENRE" ascending:YES];
    
    NSSortDescriptor *descriptor2=[[NSSortDescriptor alloc] initWithKey:@"DISTANCE.intValue" ascending:YES];
    
    
    //NSArray *sortedArr = [dataArray sortedArrayUsingDescriptors:@[descriptor1]];
    NSArray *sortedArr = [dataArray sortedArrayUsingDescriptors:@[descriptor2]];
    
    //NSLog(@"%@",[sortedArr description]);
    
#pragma mark - Draw Pie Chart
    // Values
    
    NSArray *values = @[[NSNumber numberWithInt:shop_c]
                        ,[NSNumber numberWithInt:food_c]
                        ,[NSNumber numberWithInt:other_c]
                        ,[NSNumber numberWithInt:test1]
                        ,[NSNumber numberWithInt:test2]
                        ,[NSNumber numberWithInt:test3]
                        ,[NSNumber numberWithInt:test4]
                        ,[NSNumber numberWithInt:test5]
                        ,[NSNumber numberWithInt:test6]
                        ,[NSNumber numberWithInt:test7]
                        ];
    
    
    //NSArray *values = @[@20, @30, @15, @5];
    
    // Colors
    UIColor *color1 = [UIColor magentaColor];
    UIColor *color2 = [UIColor greenColor];
    UIColor *color3 = [UIColor blueColor];
    UIColor *color4 = [UIColor yellowColor];
    UIColor *color5 = [UIColor purpleColor];
    UIColor *color6 = [UIColor redColor];
    UIColor *color7 = [UIColor magentaColor];
    UIColor *color8 = [UIColor greenColor];
    UIColor *color9 = [UIColor yellowColor];
    UIColor *color10 = [UIColor blueColor];
    
    NSArray *colors = @[color1, color2, color3, color4,color5,color6,color7,color8,color9,color10];
    
    // Doughnut Chart
    TWRCircularChart *pieChart = [[TWRCircularChart alloc] initWithValues:values
                                                                   colors:colors
                                                                     type:TWRCircularChartTypeDoughnut
                                                                 animated:NO];
    
    // You can even leverage callbacks when chart animation ends!
    [_chartView loadCircularChart:pieChart];
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
