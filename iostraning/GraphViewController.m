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
@property (nonatomic, assign) int conveni;
@property (nonatomic, assign) int shop;
@property (nonatomic, assign) int gs;
@property (nonatomic, assign) int food;
@property (nonatomic, assign) int other;

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
    
    //// 現在地の取得処理の開始部分
    // 現在地取得開始
    locationManager_ = [[CLLocationManager alloc] init];
    [locationManager_ setDelegate:self];
    locationManager_.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager_.distanceFilter = 25.0f;//25m移動するごとに測位値を返却する
    [locationManager_ startUpdatingLocation];
    
    CGRect r = [[UIScreen mainScreen] bounds];
    // 縦の長さが480の場合、古いiPhoneだと判定
    if(r.size.height == 480){
        // NSLog(@"Old iPhone");
        // レイヤーの作成
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        // レイヤーサイズをビューのサイズをそろえる
        gradient.frame = CGRectMake(0, 270, 320, 80);
        
        // 開始色と終了色を設定
        gradient.colors = @[
                            // 開始色
                            (id)[UIColor whiteColor].CGColor,
                            (id)[UIColor brownColor].CGColor,
                            // 終了色
                            (id)[UIColor whiteColor].CGColor];
        
        // レイヤーを追加
        [self.view.layer insertSublayer:gradient atIndex:0];
        //// グラフ表示部分
        self.slices = [NSMutableArray arrayWithCapacity:10];
        
        for(int i = 0; i < 5; i ++)
        {
            NSNumber *one = [NSNumber numberWithInt:rand()%10];
            [_slices addObject:one];
        }
        
        [self.pieChart setDelegate:self];
        [self.pieChart setDataSource:self];
        [self.pieChart setPieCenter:CGPointMake(100,94)];
        [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:28]];
        [self.pieChart setShowPercentage:NO];
        [self.pieChart setLabelColor:[UIColor blackColor]];
        [self.pieChart setLabelRadius:66];
        
        self.sliceColors =[NSArray arrayWithObjects:
                           [UIColor colorWithRed:1 green:0.27 blue:0 alpha:1],
                           [UIColor colorWithRed:0.486 green:1 blue:0 alpha:1],
                           [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1],
                           [UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:1],
                           [UIColor colorWithRed:0.54 green:0.55 blue:0.56 alpha:1],
                           nil];
    }else{
        // NSLog(@"New iPhone");
        // レイヤーの作成
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        // レイヤーサイズをビューのサイズをそろえる
        gradient.frame = CGRectMake(0, 360, 320, 80);
        
        // 開始色と終了色を設定
        gradient.colors = @[
                            // 開始色
                            (id)[UIColor whiteColor].CGColor,
                            (id)[UIColor brownColor].CGColor,
                            // 終了色
                            (id)[UIColor whiteColor].CGColor];
        
        // レイヤーを追加
        [self.view.layer insertSublayer:gradient atIndex:0];
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
                           [UIColor colorWithRed:0.54 green:0.55 blue:0.56 alpha:1],
                           nil];
    }
    
    //NSLog(@"%@",[self.sliceColors description]);
    
}


//touchによる遷移
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    switch (touch.view.tag) {
        case 1:
            // タグが1のビュー
            NSLog(@"ImageView1に触った");
            [self performSegueWithIdentifier:@"ToDetail" sender:_conviniArr];
            break;
        case 2:
            // タグが2のビュー
            NSLog(@"ImageView2に触った");
            [self performSegueWithIdentifier:@"ToDetail" sender:_shopArr];
            break;
        case 3:
            // タグが3のビュー
            NSLog(@"ImageView3に触った");
            [self performSegueWithIdentifier:@"ToDetail" sender:_gasArr];
            break;
        case 4:
            // タグが4のビュー
            NSLog(@"ImageView4に触った");
            [self performSegueWithIdentifier:@"ToDetail" sender:_foodArr];
            break;
        case 5:
            // タグが5のビュー
            NSLog(@"ImageView5に触った");
            [self performSegueWithIdentifier:@"ToDetail" sender:_otherArr];
            break;
        default:
            // それ以外
            NSLog(@"Viewに触った");
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SpecifiedViewController *c = segue.destinationViewController;
    c.detailArr = (NSMutableArray *)sender;
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
    // 15日前の日付を生成
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:-15*24*60*60];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour ;
    comps = [calendar components:flags fromDate:now];
    // 15日前の日付の年・月・日をそれぞれNSIntegerに格納
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
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&limit=%d&client_id=ICIWPLPZATTTPYV0YBSVB4AQCF2PVXUWKHS3ZT1BURV0PS02&client_secret=T5SEMJSHYURT5UGERXLZNCUGI1QZ1JJHWBYN2XLDWK3FQUFN&v=%04ld%02ld%02ld&locale=ja", latitude, longitude,limit,(long)year,(long)month,(long)day];
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
                Bpoint = [Bpoint arrayByAddingObject:[NSNumber numberWithInt:[Apoint distanceFromLocation:B]]];
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

- (void)redrawChart:(float)convini_d convini_c:(int)convini_c shop_d:(float)shop_d shop_c:(int)shop_c gas_d:(float)gas_d gas_c:(int)gas_c food_d:(float)food_d food_c:(int)food_c other_c:(int)other_c other_d:(float)other_d
{
    //// アイコン拡大縮小処理
    if (convini_c == 0) {
        self.conviniImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.conviniImage.hidden = YES;
        self.conviniImageG.hidden = NO;
    }else{
        //同じ座標に薄い色のuiimageviewを置き、押せないようにする。
        self.conviniImage.hidden = NO;
        self.conviniImageG.hidden = YES;
        if (convini_d < 300) {
            self.conviniImage.backgroundColor = [UIColor colorWithRed:1 green:0.27 blue:0 alpha:1];
            [self.conviniImage.layer setCornerRadius:10];
            //[self.sliceColors replaceObjectAtIndex:0 withObject:[UIColor colorWithRed:1 green:0.27 blue:0 alpha:1]];
        }else if (convini_d < 1000){
            self.conviniImage.backgroundColor = [UIColor colorWithRed:1 green:0.27 blue:0 alpha:0.4];
            [self.conviniImage.layer setCornerRadius:20];
            //[self.sliceColors replaceObjectAtIndex:0 withObject:[UIColor colorWithRed:1 green:0.27 blue:0 alpha:0.5]];
        }else{
            self.conviniImage.backgroundColor = [UIColor colorWithRed:1 green:0.27 blue:0 alpha:0.2];
            [self.conviniImage.layer setCornerRadius:30];
        }
    }
    
    if (shop_c == 0) {
        self.shopImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.shopImage.hidden = YES;
        self.shopImageG.hidden = NO;
    }else{
        self.shopImage.hidden = NO;
        self.shopImageG.hidden = YES;
        if (shop_d < 300) {
            self.shopImage.backgroundColor = [UIColor colorWithRed:0.486 green:1 blue:0 alpha:1];
            [self.shopImage.layer setCornerRadius:10];
            //[self.sliceColors replaceObjectAtIndex:1 withObject:[UIColor colorWithRed:0.486 green:1 blue:0 alpha:1]];
        }else if (shop_d < 1000){
            self.shopImage.backgroundColor = [UIColor colorWithRed:0.486 green:1 blue:0 alpha:0.4];
            [self.shopImage.layer setCornerRadius:20];
            //[self.sliceColors replaceObjectAtIndex:1 withObject:[UIColor colorWithRed:0.486 green:1 blue:0 alpha:0.5]];
        }else{
            self.shopImage.backgroundColor = [UIColor colorWithRed:0.486 green:1 blue:0 alpha:0.2];
            [self.shopImage.layer setCornerRadius:30];
        }
    }
    
    if (gas_c == 0) {
        self.gsImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.gsImage.hidden = YES;
        self.gsImageG.hidden = NO;
    }else{
        self.gsImage.hidden = NO;
        self.gsImageG.hidden = YES;
        if (gas_d < 300) {
            self.gsImage.backgroundColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
            [self.gsImage.layer setCornerRadius:10];
            //[self.sliceColors replaceObjectAtIndex:2 withObject:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]];
        }else if (gas_d < 1000){
            self.gsImage.backgroundColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:0.4];
            [self.gsImage.layer setCornerRadius:20];
            //[self.sliceColors replaceObjectAtIndex:2 withObject:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:0.5]];
        }else{
            self.gsImage.backgroundColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:0.2];
            [self.gsImage.layer setCornerRadius:30];
        }
    }
    
    if (food_c == 0) {
        self.gourmetImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.gourmetImage.hidden = YES;
        self.gourmetImageG.hidden = NO;
    }else{
        self.gourmetImage.hidden = NO;
        self.gourmetImageG.hidden = YES;
        if (food_d < 300) {
            self.gourmetImage.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:1];
            [self.gourmetImage.layer setCornerRadius:10];
            //[self.sliceColors replaceObjectAtIndex:3 withObject:[UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:1]];
        }else if (food_d < 1000){
            self.gourmetImage.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:0.4];
            [self.gourmetImage.layer setCornerRadius:20];
            //[self.sliceColors replaceObjectAtIndex:3 withObject:[UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:0.5]];
        }else{
            self.gourmetImage.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0.804 alpha:0.2];
            [self.gourmetImage.layer setCornerRadius:30];
        }
    }
    
    if (other_c == 0) {
        self.buildingImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.buildingImage.hidden = YES;
        self.buildingImageG.hidden = NO;
    }else{
        self.buildingImage.hidden = NO;
        self.buildingImageG.hidden = YES;
        if (other_d < 300) {
            self.buildingImage.backgroundColor = [UIColor colorWithRed:0.54 green:0.55 blue:0.56 alpha:1];
            [self.buildingImage.layer setCornerRadius:10];
            //[self.sliceColors replaceObjectAtIndex:4 withObject:[UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:1]];
        }else if (other_d < 1000){
            self.buildingImage.backgroundColor = [UIColor colorWithRed:0.54 green:0.55 blue:0.56 alpha:0.4];
            [self.buildingImage.layer setCornerRadius:20];
            //[self.sliceColors replaceObjectAtIndex:4 withObject:[UIColor colorWithRed:0.74 green:0.75 blue:0.76 alpha:0.5]];
        }else{
            self.buildingImage.backgroundColor = [UIColor colorWithRed:0.54 green:0.55 blue:0.56 alpha:0.2];
            [self.buildingImage.layer setCornerRadius:30];
        }
    }
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
    self.conviniArr = [initArr mutableCopy];
    
    int gas_c = 0;
    float gas_d = 0.0;
    self.gasArr = [initArr mutableCopy];
    
    int shop_c = 0;
    float shop_d = 0.0;
    self.shopArr = [initArr mutableCopy];
    
    int food_c = 0;
    float food_d = 0.0;
    self.foodArr = [initArr mutableCopy];
    
    int other_c = 0;
    float other_d = 0.0;
    self.otherArr = [initArr mutableCopy];
    
    for (int i= 0 ; i<[dataArray count]; i++) {
        if ([[[dataArray objectAtIndex:i] objectForKey:@"CATEGORY" ] isEqual: @"conveniencestore_"]) {
            convini_c++;
            [_conviniArr addObject:[dataArray objectAtIndex:i]];
            if (convini_d == 0) {
                convini_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
            }else{
                if ([[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue] < convini_d) {
                    convini_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
                }
            }
        }
    }
    //NSLog(@"%@",_conviniArr);
    
    for (int i= 0 ; i<[dataArray count]; i++) {
        if ([[[dataArray objectAtIndex:i] objectForKey:@"CATEGORY" ] isEqual: @"gas_"]) {
            gas_c++;
            [_gasArr addObject:[dataArray objectAtIndex:i]];
            if (gas_d == 0) {
                gas_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
            }else{
                if ([[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue] < gas_d) {
                    gas_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
                }
            }
        }
    }
    //NSLog(@"%@",_gasArr);
    
    for (int i= 0 ; i<[dataArray count]; i++) {
        if ([[[dataArray objectAtIndex:i] objectForKey:@"TYPE" ] isEqual: @"shops"]) {
            shop_c++;
            if ([[[dataArray objectAtIndex:i] objectForKey:@"CATEGORY" ] isEqual: @"gas_"]) {
                ;
            }else if([[[dataArray objectAtIndex:i] objectForKey:@"CATEGORY" ] isEqual: @"conveniencestore_"]){
                ;
            }else{
                [_shopArr addObject:[dataArray objectAtIndex:i]];
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
    //NSLog(@"%@",_shopArr);
    
    for (int i= 0 ; i<[dataArray count]; i++) {
        if ([[[dataArray objectAtIndex:i] objectForKey:@"TYPE" ] isEqual: @"food"]) {
            food_c++;
            [_foodArr addObject:[dataArray objectAtIndex:i]];
            if (food_d == 0) {
                food_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
            }else{
                if ([[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue] < food_d) {
                    food_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
                }
            }
        }
    }
    //NSLog(@"%@",_foodArr);
    
    for (int i= 0 ; i<[dataArray count]; i++) {
        if ([[[dataArray objectAtIndex:i] objectForKey:@"TYPE" ] isEqual: @"shops"]) {
            ;
        }   else if ([[[dataArray objectAtIndex:i] objectForKey:@"TYPE" ] isEqual: @"food"]){
            ;
        }else{
            [_otherArr addObject:[dataArray objectAtIndex:i]];
            if (other_d == 0) {
                other_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
            }else{
                if ([[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue] < other_d) {
                    other_d = [[[dataArray objectAtIndex:i] objectForKey:@"DISTANCE"] floatValue];
                }
            }
        }
    }
    //NSLog(@"%@",_otherArr);
    
    other_c =(int)[dataArray count]-shop_c-food_c;
    
    //NSLog(@"gas = %d, convini = %d, shop = %d, food = %d, other = %d",gas_c,convini_c,shop_c-gas_c-convini_c,food_c,other_c);
    
#pragma mark - DRAW PIE CHART
    [_slices replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:convini_c]];
    
    [_slices replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:shop_c-convini_c-gas_c]];
    
    [_slices replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:gas_c]];
    
    [_slices replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:food_c]];
    
    [_slices replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:[dataArray count]-shop_c-food_c]];
    
    shop_c = shop_c-convini_c-gas_c;
    
    [self redrawChart:convini_d convini_c:convini_c shop_d:shop_d shop_c:shop_c gas_d:gas_d gas_c:gas_c food_d:food_d food_c:food_c other_c:other_c other_d:other_d];
    
    _shop = 0;
    _conveni = 0;
    _gs = 0;
    _food = 0;
    _other = 0;
    
    _shop = shop_c;
    _conveni = convini_c;
    _gs = gas_c;
    _food = food_c;
    _other = other_c;
    
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
    switch (index) {
        case 0:
            // タグが1のビュー
            NSLog(@"ImageView1に触った");
            if (_conveni == 0) {
                ;
            }else{
                [self performSegueWithIdentifier:@"ToDetail" sender:_conviniArr];
            }
            break;
        case 1:
            // タグが2のビュー
            NSLog(@"ImageView2に触った");
            if (_shop == 0) {
                ;
            }else{
                [self performSegueWithIdentifier:@"ToDetail" sender:_shopArr];}
            break;
        case 2:
            // タグが3のビュー
            NSLog(@"ImageView3に触った");
            if(_gs == 0){
                ;
            }else{
            [self performSegueWithIdentifier:@"ToDetail" sender:_gasArr];
            }
            break;
        case 3:
            // タグが4のビュー
            NSLog(@"ImageView4に触った");
            if (_food == 0) {
                ;
            }else{
                [self performSegueWithIdentifier:@"ToDetail" sender:_foodArr];}
            break;
        case 4:
            // タグが5のビュー
            NSLog(@"ImageView5に触った");
            if (_other == 0) {
                ;
            }else{
                [self performSegueWithIdentifier:@"ToDetail" sender:_otherArr];}
            break;
        default:
            // それ以外
            NSLog(@"Viewに触った");
            break;
    }
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

@end
