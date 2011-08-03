//
//  GeotagDetailViewController.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@class APIAccessor;

@protocol ModalViewDelegate

- (void)didReceiveCoordinates:(double) latitude longitude:(double) longitude;

@end


@interface GeotagDetailViewController : UIViewController <CLLocationManagerDelegate, ModalViewDelegate>{
	IBOutlet UIImageView *imageView;
	IBOutlet UIButton *geotagButton;
	IBOutlet UIButton *refreshButton;
    IBOutlet UIButton *infoButton;
	IBOutlet UILabel *textLabel;
	CLLocationManager *lm;
	double latdouble;
	double longdouble;
	NSInteger pageid;
	NSString * imageurl;
	APIAccessor *apiAccessor;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIButton *geotagButton;
@property (nonatomic, retain) UIButton *refreshButton;
@property (nonatomic, retain) UIButton *infoButton;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) CLLocationManager *lm;
@property (nonatomic, retain) APIAccessor *apiAccessor;
@property (nonatomic, retain) NSString * imageurl;
@property (nonatomic, assign) NSInteger pageid;

- (IBAction) sendCoords:(id)sender;
- (IBAction) refreshImage:(id)sender;
- (IBAction) addManualCoords:(id)sender;
- (IBAction) toggleInfo:(id)sender;
- (void) skipImage:(id)sender;
- (void) hideImageButtons: (BOOL) blnShow;
- (void) setNewImageOnView: (NSString *) district;


@end