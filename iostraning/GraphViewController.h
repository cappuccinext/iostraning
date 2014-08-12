//
//  GraphViewController.h
//  
//
//  Created by cappuccinext on 2014/07/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XYPieChart.h"
#import "SpecifiedViewController.h"

@interface GraphViewController : UIViewController<CLLocationManagerDelegate,XYPieChartDelegate, XYPieChartDataSource>{
    
    CLLocationManager	*locationManager_;
    int limit;
    NSMutableArray      *venues_;
    NSMutableArray      *distance_;
    NSMutableArray      *lat_;
    NSMutableArray      *lng_;
    
    dispatch_queue_t mainQueue;
    dispatch_queue_t subQueue;
}

@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray *sliceColors;

@property(nonatomic, strong) NSMutableArray *conviniArr;
@property(nonatomic, strong) NSMutableArray *gasArr;
@property(nonatomic, strong) NSMutableArray *shopArr;
@property(nonatomic, strong) NSMutableArray *foodArr;
@property(nonatomic, strong) NSMutableArray *otherArr;

@property (strong, nonatomic) IBOutlet UIImageView *conviniImage;
@property (strong, nonatomic) IBOutlet UIImageView *shopImage;
@property (strong, nonatomic) IBOutlet UIImageView *gsImage;
@property (strong, nonatomic) IBOutlet UIImageView *gourmetImage;
@property (strong, nonatomic) IBOutlet UIImageView *buildingImage;
@property (strong, nonatomic) IBOutlet UIImageView *conviniImageG;
@property (strong, nonatomic) IBOutlet UIImageView *gsImageG;
@property (strong, nonatomic) IBOutlet UIImageView *buildingImageG;
@property (strong, nonatomic) IBOutlet UIImageView *shopImageG;
@property (strong, nonatomic) IBOutlet UIImageView *gourmetImageG;

@end
