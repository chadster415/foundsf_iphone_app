//
//  UserViewController.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserViewController.h"
#import "APIAccessor.h"


@implementation UserViewController
@synthesize usernameText;
@synthesize usernameLabel;
@synthesize cancelButton;
@synthesize districtLabel;
@synthesize apiAccessor;
@synthesize lm;
@synthesize usernameLabelBuffer;
@synthesize usernameTextBuffer;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"calling viewdidload");
	[super viewDidLoad];
	self.lm = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        self.lm.delegate = self;
        self.lm.desiredAccuracy = kCLLocationAccuracyBest;
        self.lm.distanceFilter = 1000.0f;
        [self.lm startUpdatingLocation];
    }
	
	if (self.apiAccessor == nil) {
		self.apiAccessor = [[APIAccessor alloc] init];
	}
	
}

- (void) viewDidAppear:(BOOL)animated {
	//TODO: change it so you don't have to pass username stuff into getUserscore, that method gets usernames directly out of NSUserDefaults
	//set usernameText to NSUserDefaults last username
	self.usernameText.text = [self.apiAccessor getCurrentlyStoredUsername];
    
    NSString *score = [self.apiAccessor getUserScore];
    if (score == nil){ score = @"0"; }
        
    NSMutableString *labelText = [[NSMutableString alloc] initWithString:@"Score: " ];
	
    [labelText appendString:score];
	self.usernameLabel.text = labelText;
    
    if (latdouble != 0 && longdouble != 0){
        NSString *district = [self.apiAccessor getCurrentNeighborhood:latdouble longitude:longdouble];
        
        if (district == nil){
            self.districtLabel.text = @"<press button below to calculate>";
        } else {	
            self.districtLabel.text = district;
        }	
    } else {
        self.districtLabel.text = @"<press button below to calculate>";
    }
    
    [labelText release];
}

- (IBAction) refreshDistrictLabel: (id) sender {
	NSLog(@"Refreshing district label..");
    NSLog(@"Latitude: %f", latdouble);
	NSLog(@"Longitude: %f", longdouble);
    NSString *district = [self.apiAccessor getCurrentNeighborhood:latdouble longitude:longdouble];
	self.districtLabel.text = district;
}	

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	NSLog(@"DID BEGIN!!");
	NSLog(@"Setting");
	NSLog(@"Setting label: %@", self.usernameLabel.text);
	NSLog(@"Setting text: %@", self.usernameText.text);
	
	self.usernameLabelBuffer = self.usernameLabel.text;
	self.usernameTextBuffer = self.usernameText.text;		
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSLog(@"pressed Done in user panel");
	NSLog(@"Textfield value is: %@", textField.text);
	NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *usernameArray = [myDefaults objectForKey:@"usernames"];
	
	//first, check if this was one of this user's past usernames
	if ([usernameArray containsObject:textField.text]){
		[textField resignFirstResponder];
		return YES;
	}	
    
    NSLog(@"Textfield length is: %i", [textField.text length]);
    NSString *textFieldText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    
    if ([textFieldText isEqualToString: @""]) {
        NSLog(@"returning YES");
        [textField resignFirstResponder];
        [textFieldText release];
        return YES;
    } else {    
	
        //then, check textfield contents by api call for if exists in system already ("add a user" api call)
        NSString *success = [self.apiAccessor addUser:textField.text];
        NSLog(@"Add user success: %@", success);
        
        if ([success isEqualToString:@"True"]){
        //if call comes back true, indicating textfield selection not yet in system
            //save textfield contents as current username to preferences, pushing the stack of usernames down one
            [self.apiAccessor addUsernameToDefaults: textField.text];
            
            //do an api call to get number of images tagged
            //api call with past=usernameString
            NSString *usercount = [self.apiAccessor getUserScore];
            NSLog(@"Add user success: %@", success);
            NSLog(@"User's count: %@", usercount);
        
            //display that number in the label under the username textbox
            NSLog(@"Success == True");
            NSMutableString *labelText = [[NSMutableString alloc] initWithString:@"Score: "];
            //[labelText appendString:usercount];
            [labelText appendString:usercount];
            
            usernameLabel.text = labelText;
            cancelButton.hidden = TRUE;
        
            [textField resignFirstResponder];
            return YES;
        } else {
        //if call comes back with a success of no
            NSLog(@"Success != True for some reason");
            
            //display error in place of label under textbox
            usernameLabel.textColor = [UIColor redColor];
            usernameLabel.text = @"Username taken. Try again.";
            cancelButton.hidden = FALSE;
            
            
            //do not remove keyboard
            return NO;
        } 
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


- (IBAction) cancel: (id) sender {
	NSLog(@"Cancelling");
	[self.usernameText resignFirstResponder];
	cancelButton.hidden = TRUE;
	NSLog(@"Setting");
	NSLog(@"Setting label: %@", self.usernameLabelBuffer);
	NSLog(@"Setting text: %@", self.usernameTextBuffer);
    
    self.usernameLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:116/255.0 alpha:1];
	self.usernameLabel.text = self.usernameLabelBuffer;
	self.usernameText.text = self.usernameTextBuffer;
	
}

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
}


@end
