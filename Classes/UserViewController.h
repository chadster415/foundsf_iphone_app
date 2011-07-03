//
//  UserViewController.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@class APIAccessor;


@interface UserViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate> {
	IBOutlet UITextField *usernameText;
	IBOutlet UILabel *usernameLabel;
	IBOutlet UIButton *cancelButton;
	IBOutlet UILabel *districtLabel;
	CLLocationManager *lm;
	double latdouble;
	double longdouble;
	APIAccessor *apiAccessor;
	NSString *usernameTextBuffer;
	NSString *usernameLabelBuffer;
}

@property (nonatomic, retain) UITextField *usernameText;
@property (nonatomic, retain) UILabel *usernameLabel;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UILabel *districtLabel;
@property (nonatomic, retain) APIAccessor *apiAccessor;
@property (nonatomic, assign) CLLocationManager *lm;
@property (nonatomic, retain) NSString *usernameTextBuffer;
@property (nonatomic, retain) NSString *usernameLabelBuffer;

- (IBAction) cancel: (id) sender;
- (IBAction) refreshDistrictLabel: (id) sender;
	
@end
