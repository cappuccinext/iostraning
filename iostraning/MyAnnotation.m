//
//  MyAnnotation.m
//  iostraning
//
//  Created by cappuccinext on 2014/07/12.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import "MyAnnotation.h"

@interface MyAnnotation ()
@property CLLocationCoordinate2D coordinate;
@end

@implementation MyAnnotation
- (id) initWithCoordinate:(CLLocationCoordinate2D)c {
    self.coordinate = c;
    return self;
}
@end
