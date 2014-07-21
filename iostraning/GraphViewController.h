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

@end
