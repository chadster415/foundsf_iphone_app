//
//  GeotagTableViewController.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeotagTableViewController.h"
#import "GeotagDetailViewController.h"
#import "GeoTaggerUtilTabsAppDelegate.h"
#import "APIAccessor.h"
#import "DistrictImage.h"


@implementation GeotagTableViewController
@synthesize districtsArray;
@synthesize geotagDetailViewController;
@synthesize apiAccessor;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//self.title = NSLocalizedString(@"Where in SF are you?","");

	NSMutableArray *array = [[NSArray alloc] initWithObjects:@"Bayview/Hunter's Point",@"Bernal Heights",@"Castro",@"Chinatown",@"Civic Center",@"Diamond Heights",@"Dogpatch",@"Downtown",@"Eureka Valley",@"Excelsior/Visitacion Valley",@"Fisherman's Wharf",@"Glen Canyon",@"Glen Park",@"Golden Gate Park",@"Haight-Ashbury",@"Hayes Valley",@"Jordan Park",@"Lower Haight",@"Marina",@"Mission",@"Mission Bay",@"Nob Hill",@"Noe Valley",@"North Beach",@"OMI/Ingleside",@"Pacific Heights",@"Parks",@"Polk Gulch",@"Portola",@"Potrero Hill",@"Presidio",@"Richmond",@"Russian Hill",@"SOMA",@"Shoreline",@"Sunset",@"Telegraph Hill",@"TenderNob",@"Tenderloin",@"Twin Peaks",@"West of Twin Peaks",@"Western Addition",@"Westwood Park",nil];
	
	
	self.districtsArray = array;
	
	[array release];
	
	if (apiAccessor == nil) {
		apiAccessor = [[APIAccessor alloc] init];
	}
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.districtsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSUInteger row = [indexPath row];
	[cell.textLabel setText:[districtsArray objectAtIndex: row]];
	
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	

	NSInteger row = [indexPath row];
	if (self.geotagDetailViewController == nil){
		GeotagDetailViewController *geotagDetail = [[GeotagDetailViewController alloc] initWithNibName:@"GeotagDetailView" bundle:nil];
		self.geotagDetailViewController = geotagDetail;
		[geotagDetail release];
	}
	
	//set up some of the detail view stuff
	self.geotagDetailViewController.title = [NSString stringWithFormat:@"%@", [districtsArray objectAtIndex:row]];
	[self.geotagDetailViewController.geotagButton setTitle:@"Geotag This!" forState:UIControlStateNormal];
	self.geotagDetailViewController.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	GeoTaggerUtilTabsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	DistrictImage *imageObj = [self.apiAccessor getDistrictImage:[districtsArray objectAtIndex:row]];
	
	//push controller onto stack
	[delegate.geotagNavController pushViewController:self.geotagDetailViewController animated:YES];
	
	//set image in detailView
	NSLog(@"PATH is: %@", imageObj.imageurl);
	NSLog(@"IMAGEURL is: ||%@||", imageObj.imageurl);
	NSLog(@"PAGEID is: %i", imageObj.pageid);
    
    if (imageObj.imageurl == NULL || [imageObj.imageurl isEqualToString:@"" ]){
        //hide all the buttons and return
        self.geotagDetailViewController.infoButton.hidden = YES;
        self.geotagDetailViewController.geotagButton.hidden = YES;
        self.geotagDetailViewController.refreshButton.hidden = YES;
        self.geotagDetailViewController.textLabel.hidden = YES;
        self.geotagDetailViewController.imageView.image = nil;
        return;
    } else {
        //show all the buttons
        self.geotagDetailViewController.infoButton.hidden = NO;
        self.geotagDetailViewController.geotagButton.hidden = NO;
        self.geotagDetailViewController.refreshButton.hidden = NO;
        self.geotagDetailViewController.textLabel.hidden = NO;
    }

	NSURL *url = [NSURL URLWithString:imageObj.imageurl];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *urlImage = [[UIImage alloc] initWithData:data];

	self.geotagDetailViewController.imageView.image = urlImage;
	self.geotagDetailViewController.pageid = imageObj.pageid;
	self.geotagDetailViewController.imageurl = imageObj.imageurl;
    
    NSLog(@"String: %@", imageObj.imagetext);
    self.geotagDetailViewController.textLabel.hidden = YES;
    if ([imageObj.imagetext isEqualToString:@"Not found"]){
        //if there is no comment for the image, set the comment to the image's url only
        self.geotagDetailViewController.textLabel.text = imageObj.imageurl;
    } else {
        //else set the comment to the comment plus the image's url
        self.geotagDetailViewController.textLabel.text = [[NSArray arrayWithObjects:imageObj.imagetext, imageObj.imageurl, nil] componentsJoinedByString:@"\n\n"];
    }
    
	[urlImage release];

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[super dealloc];
	[geotagDetailViewController release];
	[apiAccessor release];    
}


@end

