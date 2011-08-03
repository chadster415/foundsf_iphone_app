//
//  GeotagDetailViewController.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeotagDetailViewController.h"
#import "APIAccessor.h"
#import "DistrictImage.h"
#import "GeotagDetailMapViewController.h"


@implementation GeotagDetailViewController
@synthesize imageView;
@synthesize geotagButton;
@synthesize refreshButton;
@synthesize infoButton;
@synthesize textLabel;
@synthesize lm;
@synthesize apiAccessor;
@synthesize imageurl;
@synthesize pageid;

- (IBAction) sendCoords:(id)sender {	
	NSString *btnTitle = self.geotagButton.currentTitle;
	NSLog(@" The button's title is %@.", btnTitle);
	NSLog(@" The district should be %@.", self.title);
    
	if (![btnTitle isEqualToString:@"Sent!"]){
		NSLog(@"Sending coords..");
		[apiAccessor sendCoords:latdouble longitude:longdouble district:self.title imageurl:self.imageurl pageid:self.pageid];		
		[self.geotagButton setTitle:@"Sent!" forState:UIControlStateNormal];
	} else {
		NSLog(@"Doing nothing..");
	}	
	
}

- (void) skipImage:(id)sender {
    //do skip api call
    [apiAccessor skipImage:self.imageurl];
    NSLog(@"Skipping!");
}

- (IBAction) refreshImage:(id)sender {
    //if the geotag button's label is still "Geotag this!", the user wants to skip
    NSString *btnTitle = self.geotagButton.currentTitle;
    if ([btnTitle isEqualToString:@"Geotag This!"]){
       [self skipImage: sender]; 
    }    
    [self setNewImageOnView: self.title];
}

- (void) setNewImageOnView: (NSString *) district {
    //now just refresh the image as usual
	DistrictImage *imageObj  = [self.apiAccessor getDistrictImage:district];
	
    DLog(@"PATH is: %@", imageObj.imageurl);
	DLog(@"IMAGEURL is: ||%@||", imageObj.imageurl);
	DLog(@"PAGEID is: %i", imageObj.pageid);
    
    if (imageObj.imageurl == NULL || [imageObj.imageurl isEqualToString:@"" ]){
        //hide all the buttons and return
        [self hideImageButtons:YES];
        self.imageView.image = nil;
        return;
    } else {
        //do not hide the buttons
        [self hideImageButtons:NO];
    }
	
	NSURL *url = [NSURL URLWithString:imageObj.imageurl];	
	NSData *data = [NSData dataWithContentsOfURL:url];	
	UIImage *urlImage = [[UIImage alloc] initWithData:data];
	
    self.imageView.image = urlImage;
	self.pageid = imageObj.pageid;
    self.imageurl = imageObj.imageurl;
    
    DLog(@"String: %@", imageObj.imagetext);
    
    self.textLabel.hidden = YES;
    if ([imageObj.imagetext isEqualToString:@"Not found"]){
        //if there is no comment for the image, set the comment to the image's url only
        self.textLabel.text = imageObj.imageurl;
    } else {
        //else set the comment to the comment plus the image's url
        self.textLabel.text = [[NSArray arrayWithObjects:imageObj.imagetext, imageObj.imageurl, nil] componentsJoinedByString:@"\n\n"];
    }
    	
	[urlImage release];	
	
	[self.geotagButton setTitle:@"Geotag This!" forState:UIControlStateNormal];
}

- (void) hideImageButtons: (BOOL) blnShow {
    self.infoButton.hidden = blnShow;
    self.geotagButton.hidden = blnShow;
    self.refreshButton.hidden = blnShow;
    self.textLabel.hidden = blnShow;
}

- (IBAction) addManualCoords:(id)sender {
    NSLog(@"calling addManualCoords");
    
    NSString *btnTitle = self.geotagButton.currentTitle;
	NSLog(@" The button's title is %@.", btnTitle);
	
	if (![btnTitle isEqualToString:@"Sent!"]){
        GeotagDetailMapViewController *mapViewController = [[[GeotagDetailMapViewController alloc] init] autorelease];
        mapViewController.delegate = self;
        mapViewController.initialLat = latdouble;
        mapViewController.initialLong = longdouble;
        [self presentModalViewController:mapViewController animated:YES];
	} else {
		NSLog(@"Doing nothing..");
	}    
    
}

- (void) toggleInfo:(id)sender {
    if (self.textLabel.hidden == YES){
        self.textLabel.hidden = NO;
    } else {
        self.textLabel.hidden = YES;
    }
}

- (void)didReceiveCoordinates:(double)latitude longitude:(double)longitude {
    NSLog(@"Message!: %f, %f", latitude, longitude);
    latdouble = latitude;
    longdouble = longitude;
    [self sendCoords:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.lm = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        self.lm.delegate = self;
        self.lm.desiredAccuracy = kCLLocationAccuracyBest;
        self.lm.distanceFilter = 1000.0f;
        [self.lm startUpdatingLocation];
    }
	
	if (apiAccessor == nil) {
		apiAccessor = [[APIAccessor alloc] init];
	}

}

- (void) locationManager: (CLLocationManager *) manager
	 didUpdateToLocation: (CLLocation *) newLocation
			fromLocation: (CLLocation *) oldLocation{

	latdouble = newLocation.coordinate.latitude;
	longdouble = newLocation.coordinate.longitude;
	
	self.lm = manager;
	
    NSString *lat = [[NSString alloc] initWithFormat:@"%g", 
					 newLocation.coordinate.latitude];
    NSLog(@"Latitude: %@", lat);
    
    NSString *lng = [[NSString alloc] initWithFormat:@"%g", 
					 newLocation.coordinate.longitude];
    NSLog(@"Longitude: %@", lng);
    
    NSString *acc = [[NSString alloc] initWithFormat:@"%g", 
					 newLocation.horizontalAccuracy];
    NSLog(@"Accuracy: %@", acc);    
    
    [acc release];
    [lat release];
    [lng release];

}	

- (void) locationManager: (CLLocationManager *) manager
		didFailWithError: (NSError *) error {

    NSString *msg = [[NSString alloc] 
					 initWithString:@"Error obtaining location"];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error" 
                          message:msg 
                          delegate:nil 
                          cancelButtonTitle: @"Done"
                          otherButtonTitles:nil];
    [alert show];    
    [msg release];
    [alert release];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[super dealloc];
	[apiAccessor release];
    [imageView release];
    [geotagButton release];
    [refreshButton release];
    [textLabel release];
	[lm release];
}


@end
