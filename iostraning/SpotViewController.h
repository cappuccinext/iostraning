//
//  SpotViewController.h
//  iostraning
//
//  Created by cappuccinext on 2014/07/10.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SpotViewController : UITableViewController<CLLocationManagerDelegate>{
    CLLocationManager	*locationManager_;
    NSArray *sendArr;
    
    NSMutableArray      *venues_;
    NSMutableArray      *distance_;
    NSMutableArray      *lat_;
    NSMutableArray      *lng_;
    int                 limit;
    
    dispatch_queue_t mainQueue;
    dispatch_queue_t subQueue;
}

@end
