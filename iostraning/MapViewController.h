//
//  MapViewController.h
//  iostraning
//
//  Created by cappuccinext on 2014/07/12.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property NSDictionary *mapDic;
@property (weak, nonatomic) IBOutlet MKMapView *spotmap;
@property NSString *string;

@end
