//
//  MapViewController.m
//  iostraning
//
//  Created by cappuccinext on 2014/07/12.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize string = _string;
@synthesize spotmap;

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
    // Do any additional setup after loading the view.
    
    NSLog(@"mapDic = %@",[self.mapDic description]);
    
    self.spotmap.delegate = self;
    
    MyAnnotation* pin = [[MyAnnotation alloc] init];
    pin.coordinate = CLLocationCoordinate2DMake([self.mapDic[@"LATITUDE"] floatValue], [self.mapDic[@"LONGITUDE"] floatValue]); // 緯度経度
    pin.title = self.mapDic[@"SPOT"];//タイトル
    pin.subtitle = self.mapDic[@"GENRE"];//サブタイトル
    [self.spotmap addAnnotation:pin];

    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;
    region.center.latitude = [[self.mapDic objectForKey:@"LATITUDE"] floatValue];
    region.center.longitude = [[self.mapDic objectForKey:@"LONGITUDE"] floatValue];
    [spotmap setRegion:region animated:NO];
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
#pragma mark - MKMapViewDelegate
// マップデータの読み込み開始直前に呼ばれる
-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    NSLog(@"%s",__func__);
}

// マップデータの読み込み完了後に呼ばれる
-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"%s",__func__);
    NSLog(@"%lu",(unsigned long)[spotmap.annotations count]);
    for (id<MKAnnotation> currentAnnotation in spotmap.annotations) {
        if ([currentAnnotation isEqual:spotmap.userLocation]) {
            ;
        }else{
            [spotmap selectAnnotation:currentAnnotation animated:YES];
        }
    }
    //[spotmap selectAnnotation:spotmap.userLocation animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation
{
    static NSString* Identifier = @"PinAnnotationIdentifier";
    MKPinAnnotationView* pinView =
    (MKPinAnnotationView *)[spotmap dequeueReusableAnnotationViewWithIdentifier:Identifier];
    
    // 現在地表示なら nil を返す
    if (annotation == spotmap.userLocation) {
        return nil;
    }
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:Identifier];
        pinView.animatesDrop = YES;     // 落下アニメーションありなし
        pinView.canShowCallout = YES;  // 吹き出し表示するか
        pinView.draggable = YES;           // ドラッグできるか
        pinView.rightCalloutAccessoryView =
        [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; // 右側にアクセサリ
    } else {
        pinView.annotation = annotation;
    }
    return pinView;
}

// ピンのアクセサリタップ時のイベント
- (void) mapView:(MKMapView*)_mapView annotationView:(MKAnnotationView*)annotationView calloutAccessoryControlTapped:(UIControl*)control {
    // タップしたときの処理
    NSLog(@"%s アクセサリタップ",__func__);
    MyAnnotation* pin = (MyAnnotation*)annotationView.annotation;
    NSLog(@"title:%@",pin.title);
    
    float orientation_lat = spotmap.userLocation.location.coordinate.latitude;
    float orientation_lng = spotmap.userLocation.location.coordinate.longitude;
    float destination_lat = [self.mapDic[@"LATITUDE"] floatValue];
    float destination_lng = [self.mapDic[@"LONGITUDE"] floatValue];
    
    NSString *requestURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",orientation_lat,orientation_lng,destination_lat,destination_lng];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestURL]];
    
    /*
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        float startLat = orientation_lat;
        float startLon = orientation_lng;
        float goalLat  = destination_lat;
        float goalLon  = destination_lng;
        
        NSString *requestURL = [NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&directionsmode=walking",startLat,startLon,goalLat,goalLon];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestURL]];
    }else{
        NSLog(@"ERROR");
    }*/
}



@end
