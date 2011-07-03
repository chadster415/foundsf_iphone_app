//
//  GeotagDetailMapViewController.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol ModalViewDelegate;

@interface GeotagDetailMapViewController : UIViewController <MKMapViewDelegate> {
    id<ModalViewDelegate> delegate;
    UIButton *dismissViewButton;
    IBOutlet MKMapView *mapView;
    double initialLat;
    double initialLong;
    double finalLat;
    double finalLong;
}

@property (nonatomic, retain) IBOutlet UIButton *dismissViewButton;
@property (nonatomic, assign) id<ModalViewDelegate> delegate;
@property (nonatomic, assign) MKMapView *mapView;
@property (nonatomic, assign) double initialLat;
@property (nonatomic, assign) double initialLong;
@property (nonatomic, assign) double finalLat;
@property (nonatomic, assign) double finalLong;

- (IBAction)dismissView:(id)sender;
- (void)coordinateChanged_:(NSNotification *)notification;

@end