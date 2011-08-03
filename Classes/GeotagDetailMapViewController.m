//
//  GeotagDetailMapViewController.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeotagDetailMapViewController.h"
#import "GeotagDetailViewController.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"


@implementation GeotagDetailMapViewController

@synthesize delegate;
@synthesize dismissViewButton;
@synthesize mapView;
@synthesize initialLat;
@synthesize initialLong;
@synthesize finalLat;
@synthesize finalLong;

- (IBAction)dismissView:(id)sender {
    [delegate didReceiveCoordinates:finalLat longitude:finalLong] ;
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = initialLat;
    theCoordinate.longitude = initialLong;
    //initialize these in case user does not move map pin
    finalLat = initialLat;
    finalLong = initialLong;
    
    
    MKCoordinateSpan mapSpan; 
    mapSpan.latitudeDelta = 0.005; 
    mapSpan.longitudeDelta = 0.005;
    MKCoordinateRegion mapRegion; 
    mapRegion.center = theCoordinate; 
    mapRegion.span = mapSpan;
    self.mapView.region = mapRegion; 
    self.mapView.mapType = MKMapTypeHybrid;
	
	DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];
	annotation.title = @"Drag to Move Pin";
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	
	[self.mapView addAnnotation:annotation];
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"Calling viewWillAppear");
    NSLog(@"Latitude: %f", initialLat);
    NSLog(@"Longitude: %f", initialLong);
    
    [super viewWillAppear:animated];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];	
}

- (void)dealloc {
	mapView.delegate = nil;
    [dismissViewButton release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification

// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification {
	
	DDAnnotation *annotation = notification.object;
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
    finalLat = annotation.coordinate.latitude;
    finalLong = annotation.coordinate.longitude;
    
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
        finalLat = annotation.coordinate.latitude;
        finalLong = annotation.coordinate.longitude;
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {
		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:self.mapView];
        
		if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
			// draggablePinView is DDAnnotationView on iOS 3.
		} else {
			// draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
		}
	}		
	
	return draggablePinView;
}

@end
