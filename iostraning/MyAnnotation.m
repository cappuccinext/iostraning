//
//  MyAnnotation.m
//  iostraning
//
//  Created by cappuccinext on 2014/07/12.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
- (id)initWithCoordinates:(CLLocationCoordinate2D)_coordinate title:(NSString *)_title subtitle:(NSString *)_subtitle;
{
    self = [super self];
    if(self != nil){
        coordinate = _coordinate;
        title = _title;
        subtitle = _subtitle;
    }
    return self;
}
@end
