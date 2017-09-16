//
//  CustomerMapAnnotation.h
//  FFO
//
//  Created by Pawan kumar on 6/14/17.
//  Copyright © 2017 Pawan kumar. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomerMapAnnotation : NSObject<MKAnnotation>
{
    NSString * title;
    NSString * name;
    NSString * subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@end
