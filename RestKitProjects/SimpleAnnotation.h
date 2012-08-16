//
//  SimpleAnnotation.h
//  RestKitProjects
//
//  Created by Rose CW on 8/15/12.
//  Copyright (c) 2012 Rose CW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SimpleAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@end
