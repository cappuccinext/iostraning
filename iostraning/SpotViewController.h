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
    NSArray *dataMain;
    NSArray *dataDetail;
    CLLocationManager	*locationManager_;
    NSArray *sendArr;
    
    NSMutableArray      *venues_;
    NSMutableArray      *distance_;
    NSMutableArray      *lat_;
    NSMutableArray      *lng_;
    int                 limit;
}

@end
