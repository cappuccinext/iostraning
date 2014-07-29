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
    
    //タイトル表示
    self.title = @"ジャンル別グラフ表示";
    //// グラデーション部分（アイコン表示部分）の作成
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
    
    //// 現在地の取得処理の開始部分
    // 現在地取得開始
    locationManager_ = [[CLLocationManager alloc] init];
    [locationManager_ setDelegate:self];
    locationManager_.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager_.distanceFilter = 25.0f;//25m移動するごとに測位値を返却する
    [locationManager_ startUpdatingLocation];
    
    //// グラフ表示部分
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    for(int i = 0; i < 5; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%10];
        [_slices addObject:one];
    }
    
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setPieCenter:CGPointMake(130,130)];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:28]];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    [self.pieChart setLabelRadius:90];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:1 green:0.27 blue:0 alpha:1],
                       [UIColor colorWithRed:0.486 green:1 blue:0 alpha:1],
                       [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1],
                       [UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:1],
                       [UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:1],
                       nil];
    
    NSLog(@"%@",[self.sliceColors description]);
    
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
    
    mainQueue = dispatch_get_main_queue();
    subQueue = dispatch_queue_create("net.sakasoinfo.iostraning.jsonqueue", 0);
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
    limit = 25;
    // URL文字列を作成
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&limit=%d&client_id=ICIWPLPZATTTPYV0YBSVB4AQCF2PVXUWKHS3ZT1BURV0PS02&client_secret=T5SEMJSHYURT5UGERXLZNCUGI1QZ1JJHWBYN2XLDWK3FQUFN&v=%04ld%02ld%02ld", latitude, longitude,limit,(long)year,(long)month,(long)day];
    // jsonデータを取得
    
    dispatch_async(subQueue, ^{NSURL *url = [NSURL URLWithString:urlString];
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
                                     error:0];
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
            
            for (int i=0 ; i < [responseLAT count] ; i++)
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
                // jsonDataからjsonDicに変換するときにエラーが発生したときに落ちる先
                NSLog(@"Error: %@", [error localizedDescription]);
                return;
            }
            //テーブルビューのdatasourceを再読み込みする
            dispatch_async(mainQueue,^{
                [self loadPieChart];});
        }
    });
    
}

- (void)loadPieChart
{
#pragma mark - PROCESSING JSON DATA
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
    
    
    //4番目の区切りの内容（施設タイプ）を抜き出しarrTYPEに格納
    for (int i = 0; i < [arrURL count] ; i++){
        if ([[arrURL objectAtIndex:i] isEqual:@"NODATA"]) {
            arrTYPE = [arrTYPE arrayByAddingObject:@"NODATA"];
        }else{
            samplepath = [arrURL objectAtIndex:i];
            NSArray *temparr;
            temparr = [samplepath pathComponents];
            arrTYPE = [arrTYPE arrayByAddingObject:[temparr objectAtIndex:4]];
        }
    }
    //5番目の区切りの内容（施設詳細タイプ）を抜き出しarrCATEGORYに格納
    for (int i = 0; i < [arrURL count] ; i++){
        if ([[arrURL objectAtIndex:i] isEqual:@"NODATA"]) {
            arrCATEGORY = [arrCATEGORY arrayByAddingObject:@"NODATA"];
        }else{
            samplepath = [arrURL objectAtIndex:i];
            NSArray *temparr;
            temparr = [samplepath pathComponents];
            arrCATEGORY = [arrCATEGORY arrayByAddingObject:[temparr objectAtIndex:5]];
        }
    }
    
    NSArray *dataArray = [NSArray array];
    
    //dictinaryWithOptionsAndKeys
    for (int i = 0; i < [distance_ count] ; i++) {
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
                              ,[lat_ objectAtIndex:i]
                              ,@"LATITUDE"
                              ,[lng_ objectAtIndex:i]
                              ,@"LONGITUDE"
                              , nil];
        dataArray = [dataArray arrayByAddingObject:mdic];
    }
    
    //dataArray検証用
    //NSLog(@"%@",[dataArray description]);
    
    NSArray *initArr = @[];
    
    int convini_c = 0;
    float convini_d = 0.0;
    NSMutableArray *conviniArr = [initArr mutableCopy];
    
    int gas_c = 0;
    float gas_d = 0.0;
    NSMutableArray *gasArr = [initArr mutableCopy];
    
    int shop_c = 0;
    float shop_d = 0.0;
    NSMutableArray *shopArr = [initArr mutableCopy];
    
    int food_c = 0;
    float food_d = 0.0;
    NSMutableArray *foodArr = [initArr mutableCopy];
    
    int other_c = 0;
    float other_d = 0.0;
    NSMutableArray *otherArr = [initArr mutableCopy];
    
    for (int i= 0 ; i<[dataArray count]; i++) {
        if ([[[dataArray objectAtIndex:i] objectForKey:@"CATEGORY" ] isEqual: @"conveniencestore_"]) {
            convini_c++;
            [conviniArr addObject:[dataArray objectAtIndex:i]];
            if (convini_d == 0) {
                convini_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
            }else{
                if ([[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue] < convini_d) {
                    convini_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
                }
            }
        }
    }
    //NSLog(@"%@",conviniArr);
    
    for (int i= 0 ; i<[dataArray count]; i++) {
        if ([[[dataArray objectAtIndex:i] objectForKey:@"CATEGORY" ] isEqual: @"gas_"]) {
            gas_c++;
            [gasArr addObject:[dataArray objectAtIndex:i]];
            if (gas_d == 0) {
                gas_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
            }else{
                if ([[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue] < gas_d) {
                    gas_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
                }
            }
        }
    }
    //NSLog(@"%@",gasArr);
    
    for (int i= 0 ; i<[dataArray count]; i++) {
        if ([[[dataArray objectAtIndex:i] objectForKey:@"TYPE" ] isEqual: @"shops"]) {
            shop_c++;
            if ([[[dataArray objectAtIndex:i] objectForKey:@"CATEGORY" ] isEqual: @"gas_"]) {
                ;
            }else if([[[dataArray objectAtIndex:i] objectForKey:@"CATEGORY" ] isEqual: @"conveniencestore_"]){
                ;
            }else{
                [shopArr addObject:[dataArray objectAtIndex:i]];
                if (shop_d == 0) {
                    shop_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
                }else{
                    if ([[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue] < shop_d) {
                        shop_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
                    }
                }
            }
        }
    }
    //NSLog(@"%@",shopArr);
    
    for (int i= 0 ; i<[dataArray count]; i++) {
        if ([[[dataArray objectAtIndex:i] objectForKey:@"TYPE" ] isEqual: @"food"]) {
            food_c++;
            [foodArr addObject:[dataArray objectAtIndex:i]];
            if (food_d == 0) {
                food_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
            }else{
                if ([[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue] < food_d) {
                    food_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
                }
            }
        }
    }
    //NSLog(@"%@",foodArr);
    
    for (int i= 0 ; i<[dataArray count]; i++) {
        if (([[[dataArray objectAtIndex:i] objectForKey:@"TYPE" ] isEqual: @"building"])|| ([[[dataArray objectAtIndex:i] objectForKey:@"TYPE" ] isEqual: @"travel"])|| ([[[dataArray objectAtIndex:i] objectForKey:@"TYPE" ] isEqual: @"parks_outdoors"])|| ([[[dataArray objectAtIndex:i] objectForKey:@"TYPE" ] isEqual: @"NODATA"])) {
            [otherArr addObject:[dataArray objectAtIndex:i]];
            if (other_d == 0) {
                other_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
            }else{
                if ([[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue] < other_d) {
                    other_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
                }
            }
        }
    }
    //NSLog(@"%@",otherArr);
    
    other_c =(int)[dataArray count]-shop_c-food_c;
    
    NSLog(@"gas = %d, convini = %d, shop = %d, food = %d, other = %d",gas_c,convini_c,shop_c-gas_c-convini_c,food_c,other_c);
    
#pragma mark - DRAW PIE CHART
    [_slices replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:convini_c]];
    
    [_slices replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:shop_c-convini_c-gas_c]];
    
    [_slices replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:gas_c]];
    
    [_slices replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:food_c]];
    
    [_slices replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:[dataArray count]-shop_c-food_c]];
    
    //// アイコン拡大縮小処理
    if (convini_c == 0) {
        self.conviniImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }else{
    if (convini_d < 300) {
        self.conviniImage.backgroundColor = [UIColor colorWithRed:1 green:0.27 blue:0 alpha:1];
        [self.conviniImage.layer setCornerRadius:10];
        //[self.sliceColors replaceObjectAtIndex:0 withObject:[UIColor colorWithRed:1 green:0.27 blue:0 alpha:1]];
    }else{
        self.conviniImage.backgroundColor = [UIColor colorWithRed:1 green:0.27 blue:0 alpha:0.5];
        [self.conviniImage.layer setCornerRadius:10];
        //[self.sliceColors replaceObjectAtIndex:0 withObject:[UIColor colorWithRed:1 green:0.27 blue:0 alpha:0.5]];
    }
    }
    
    if (shop_c == 0) {
        self.shopImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }else{
    if (shop_d < 300) {
        self.shopImage.backgroundColor = [UIColor colorWithRed:0.486 green:1 blue:0 alpha:1];
        [self.shopImage.layer setCornerRadius:10];
        //[self.sliceColors replaceObjectAtIndex:1 withObject:[UIColor colorWithRed:0.486 green:1 blue:0 alpha:1]];
    }else{
        self.shopImage.backgroundColor = [UIColor colorWithRed:0.486 green:1 blue:0 alpha:0.5];
        [self.shopImage.layer setCornerRadius:10];
        //[self.sliceColors replaceObjectAtIndex:1 withObject:[UIColor colorWithRed:0.486 green:1 blue:0 alpha:0.5]];
    }}
    
    if (gas_c == 0) {
        self.gsImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }else{
    if (gas_d < 300) {
        self.gsImage.backgroundColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
        [self.gsImage.layer setCornerRadius:10];
        //[self.sliceColors replaceObjectAtIndex:2 withObject:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]];
    }else{
        self.gsImage.backgroundColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:0.5];
        [self.gsImage.layer setCornerRadius:10];
        //[self.sliceColors replaceObjectAtIndex:2 withObject:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:0.5]];
    }}
    
    if (food_c == 0) {
        self.gourmetImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }else{
    if (food_d < 300) {
        self.gourmetImage.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:1];
        [self.gourmetImage.layer setCornerRadius:10];
        //[self.sliceColors replaceObjectAtIndex:3 withObject:[UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:1]];
    }else{
        self.gourmetImage.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:0.5];
        [self.gourmetImage.layer setCornerRadius:10];
        //[self.sliceColors replaceObjectAtIndex:3 withObject:[UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:0.5]];
    }}
    
    if (other_c == 0) {
        self.buildingImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    if (other_d < 300) {
        self.buildingImage.backgroundColor = [UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:1];
        [self.buildingImage.layer setCornerRadius:10];
        //[self.sliceColors replaceObjectAtIndex:4 withObject:[UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:1]];
    }else{
        self.buildingImage.backgroundColor = [UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:0.5];
        [self.buildingImage.layer setCornerRadius:10];
        //[self.sliceColors replaceObjectAtIndex:4 withObject:[UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:0.5]];
    }
    
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
