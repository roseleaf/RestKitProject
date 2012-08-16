//
//  ViewController.m
//  RestKitProjects
//
//  Created by Rose CW on 8/14/12.
//  Copyright (c) 2012 Rose CW. All rights reserved.
//

#import "ViewController.h"
#import "RestKit.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "SimpleAnnotation.h"

@interface ViewController () <RKRequestDelegate, UITextFieldDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
}

@end

@implementation ViewController
@synthesize mapView;
@synthesize searchField;



- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [CLLocationManager new];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    [RKClient clientWithBaseURLString:@"https://maps.googleapis.com/maps/api/place"];

    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
}


- (void)viewDidUnload
{
    [self setSearchField:nil];
    [self setMapView:nil];
    [super viewDidUnload];
//self.mapView.showsUserLocation = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"User moved");
    CLLocationCoordinate2D regionCoords = userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(regionCoords, 1000, 1000);
    self.mapView.region = region;
}



-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[SimpleAnnotation class]]) {

        
        MKAnnotationView* annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];

        
        annotationView.canShowCallout = YES;
        
        return annotationView;
    } else {
        //returning nil displays the default annotation view for other annotation types
        return nil;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)searchField{
    NSString* searchItem = self.searchField.text;    
    [self fetchPlacesData:searchItem];
    [self.searchField resignFirstResponder];
    return NO;

};


-(IBAction)searchPressed {
    NSString* searchItem = self.searchField.text;
    [self fetchPlacesData:searchItem];
}




-(void)fetchPlacesData:searchItem {
    RKClient *client = [RKClient sharedClient];

    double latitude = locationManager.location.coordinate.latitude;
    double longitude = locationManager.location.coordinate.longitude;
    NSString* coordinates = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSDictionary *params = [NSDictionary dictionaryWithKeysAndObjects:
                            @"key", @"AIzaSyBsYf2AHYCgPUC1Gt7MGrC7yp3u0UqtzlY",
                            @"location", coordinates,
                            @"radius", @"500",
                            @"sensor", @"false",
                            @"keyword", searchItem,
                            nil];
    [client get:@"/search/json" queryParameters:params delegate:self];
    NSLog(@"%@",coordinates);

}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    id parsedResponse = [request.response parsedBody:nil];
    if(![parsedResponse isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", [parsedResponse class]);
        return;
    } 
    NSDictionary* searchResults = parsedResponse;
    [self parseSearchResults:searchResults];
}

-(void)parseSearchResults:(NSDictionary*)searchResults {
//    NSArray* resultsList = [NSArray new];

    NSArray* resultsListFromData = [searchResults objectForKey:@"results"];
    for (NSDictionary* result in resultsListFromData){
        NSString* googleName = [result objectForKey:@"name"];
        NSDictionary* googleGeometry = [result objectForKey:@"geometry"];
        NSDictionary* googleLocation = [googleGeometry objectForKey:@"location"];
        double googleLatitude = [[googleLocation objectForKey:@"lat"] doubleValue];
        double googleLongitude = [[googleLocation objectForKey:@"lng"] doubleValue];
        [self createAnnotation:googleName withLat:googleLatitude andWithLng:googleLongitude];


    }
}

-(void)createAnnotation:(NSString*)googleName withLat:(double)googleLatitude andWithLng:(double) googleLongitude {
    SimpleAnnotation* annotation = [SimpleAnnotation new];
    annotation.coordinate = CLLocationCoordinate2DMake(googleLatitude, googleLongitude);
    annotation.title = googleName;
    [self.mapView addAnnotation:annotation];
}

//-(void)foundLocation(CLLocation*)loc
//{
//    
//}



@end
