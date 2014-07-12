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
    
    
    CLLocationCoordinate2D coordinateYou =  CLLocationCoordinate2DMake([[self.mapDic objectForKey:@"LATITUDE"] floatValue],[[self.mapDic objectForKey:@"LONGITUDE"] floatValue] );
    NSString *titleYou = [self.mapDic objectForKey:@"SPOT"];
    NSString *subtitleYou = [self.mapDic objectForKey:@"GENRE"];
    MyAnnotation *annotationYou = [[MyAnnotation alloc] initWithCoordinates:coordinateYou title:titleYou subtitle:subtitleYou];
    [spotmap addAnnotation:annotationYou];
    [spotmap setCenterCoordinate:coordinateYou animated:YES];
    //MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    //MKCoordinateRegion region = MKCoordinateRegionMake(spotmap.userLocation.coordinate, span);
    //[spotmap setRegion:region animated:YES];
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;
    region.center.latitude = [[self.mapDic objectForKey:@"LATITUDE"] floatValue];
    region.center.longitude = [[self.mapDic objectForKey:@"LONGITUDE"] floatValue];
    [spotmap setRegion:region animated:YES];
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
