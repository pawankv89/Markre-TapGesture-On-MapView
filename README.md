
MarkreTapGestureOnMapView
=========

## MarkreTapGestureOnMapView.
------------
 Added Some screens here.
 
[![](https://github.com/pawankv89/MarkreTapGestureOnMapView/blob/master/images/screen_1.png)]
[![](https://github.com/pawankv89/MarkreTapGestureOnMapView/blob/master/images/screen_2.png)]



## Usage
------------
 iOS Demo showing how to use Inside or outside point in polygon on iPhone 6s devices in Objective-C.

```objective-c

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
```
```objective-c

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
```


## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each this release can be found in the [CHANGELOG](CHANGELOG.mdown). 
