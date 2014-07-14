//
//  GraphViewController.h
//  
//
//  Created by cappuccinext on 2014/07/13.
//
//

#import <UIKit/UIKit.h>
#import <TWRCharts/TWRChart.h>
#import <CoreLocation/CoreLocation.h>

@interface GraphViewController : UIViewController<CLLocationManagerDelegate>{
    
    CLLocationManager	*locationManager_;
    int limit;
    NSMutableArray      *venues_;
    NSMutableArray      *distance_;
}

@property(strong, nonatomic) TWRChartView *chartView;
@end
