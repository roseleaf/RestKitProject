//
//  ViewController.h
//  RestKitProjects
//
//  Created by Rose CW on 8/14/12.
//  Copyright (c) 2012 Rose CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField
*searchField;
@property(readonly, nonatomic) CLLocation *location;
-(void)fetchPlacesData:searchItem;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
