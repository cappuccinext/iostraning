//
//  MyAnnotation.h
//  iostraning
//
//  Created by cappuccinext on 2014/07/12.
//  Copyright (c) 2014年 cappmac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString* title;         //吹き出しに表示するタイトル
@property (nonatomic, copy) NSString* subtitle;   //吹き出しに表示するサブタイトル

- (id) initWithCoordinate:(CLLocationCoordinate2D) coordinate;

@end
