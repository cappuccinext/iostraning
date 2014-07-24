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

@interface GraphViewController : UIViewController<CLLocationManagerDelegate,XYPieChartDelegate, XYPieChartDataSource>{
    
    CLLocationManager	*locationManager_;
    int limit;
    NSMutableArray      *venues_;
    NSMutableArray      *distance_;
    NSMutableArray      *lat_;
    NSMutableArray      *lng_;
}

@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@property (strong, nonatomic) IBOutlet UIImageView *conviniImage;
@property (strong, nonatomic) IBOutlet UIImageView *shopImage;
@property (strong, nonatomic) IBOutlet UIImageView *gsImage;
@property (strong, nonatomic) IBOutlet UIImageView *gourmetImage;
@property (strong, nonatomic) IBOutlet UIImageView *buildingImage;

@end
