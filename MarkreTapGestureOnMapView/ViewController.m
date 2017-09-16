//
//  ViewController.m
//  MarkreTapGestureOnMapView
//
//  Created by Pawan kumar on 9/16/17.
//  Copyright © 2017 Pawan Kumar. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "CustomerMapAnnotation.h"

@interface ViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
//When Select Customer by List or Map
@property (nonatomic) CustomerMapAnnotation *customAnnotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.mapView setDelegate:self];
    
    //create UIGestureRecognizer to detect a tap
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMarkerOnMap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[CustomerMapAnnotation class]])
    {
        NSString *customerAnnotationIdentifier = @"Custome";
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customerAnnotationIdentifier];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customerAnnotationIdentifier];
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, 0);//Manage Callout Top Posstion
            
        } else {
            
            pinView.annotation = annotation;
        }
        
        UIImage *markerIcon = [UIImage imageNamed:@"marker"];
        
        //UIImage *marker = [UIImage imageNamed:"u"];
        
        pinView.image = markerIcon;
        return pinView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Default Annotation");
    }
    
    if ([annotation isKindOfClass:[CustomerMapAnnotation class]])
    {
        NSLog(@"Clicked Customer Annotation");
        
        CustomerMapAnnotation *customerAnnotation = (CustomerMapAnnotation*)annotation;
        
        NSLog(@"CustomerMapAnnotation Annotation Title:- %@",customerAnnotation.title);
    }
}


/**
 * GeoMap Tile Overlay Rendering default delegate method of MAPKit
 *
 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKTileOverlay class]]) {
        
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
        
    }
    if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *view = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        view.fillColor=[[UIColor blueColor]colorWithAlphaComponent:0.1];
        view.strokeColor=[UIColor blueColor];
        
        view.lineWidth = 1.0;
        
        return view;
    }
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer *routeLineView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        routeLineView.fillColor = [UIColor whiteColor];
        
        routeLineView.lineWidth = 1.0f;
        
        routeLineView.strokeColor = [UIColor redColor];
        
        return routeLineView;
    }
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        
        UIColor *colorblue = [UIColor colorWithRed:36.0f/255.0f green:43.0f/255.0f blue:128.0f/255.0f alpha:0.5];
        MKPolygonRenderer *polygonView = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
        polygonView.fillColor = colorblue;
        polygonView.strokeColor = [UIColor purpleColor];
        polygonView.lineWidth = 1.0f;
        
        return polygonView;
    }
    
    return nil;
}

- (void)zoomToCurrentLocation:(CLLocationCoordinate2D)coordinate{
    
    float spanX = 0.0125;
    float spanY = 0.0125;
    MKCoordinateRegion region;
    region.center.latitude = coordinate.latitude;
    region.center.longitude = coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}

-(IBAction)addMarkerOnMap:(UITapGestureRecognizer *)recognizer{
    
    //Remove Agent Annotation before adding
    for (id annotationAgent in self.mapView.annotations) {
        
        if ([annotationAgent isKindOfClass:[CustomerMapAnnotation class]])
        {
            [self.mapView removeAnnotation:(CustomerMapAnnotation*)annotationAgent];
        }
    }
    
    //User Annotation
    if (self.customAnnotation == nil) {
        
        self.customAnnotation = [[CustomerMapAnnotation alloc] init];
    }
    
    CGPoint point = [recognizer locationInView:self.mapView];
    
    CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.view];
    
    self.customAnnotation.title = @"Name";
    self.customAnnotation.subtitle = [NSString stringWithFormat:@"Lat(%f) Lng(%f)",tapPoint.latitude,tapPoint.longitude];
    self.customAnnotation.coordinate = tapPoint;
    
    [self.mapView addAnnotation:self.customAnnotation];
    
    //Default showing Callout
    [self.mapView selectAnnotation:self.customAnnotation animated:TRUE];
    
    //Center Map Zoom Location
    [self zoomToCurrentLocation:self.customAnnotation.coordinate];
}
@end

