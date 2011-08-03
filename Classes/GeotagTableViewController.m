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
@synthesize geotagTableView;
@synthesize activityIndicatorView;
@synthesize currentCell;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

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
	
    /* spinner */
    DLog(@"starting spinner", NULL);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView startAnimating];
    //spawn thread that retrieves image
    [NSThread detachNewThreadSelector:@selector(pushImage:) toTarget:self withObject:indexPath];
    [cell setAccessoryView:activityIndicatorView];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [activityIndicatorView release];
    /* /spinner */
    
    //store this cell in a global variable so we can replace the pinner with the disclosure button later after image is rendered
    currentCell = cell;

}

- (void)pushImage:(NSIndexPath *) indexPath {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
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
	
    //    //push controller onto stack
	[delegate.geotagNavController pushViewController:self.geotagDetailViewController animated:YES];
    
    [self.geotagDetailViewController setNewImageOnView:[districtsArray objectAtIndex:row]];  
    [activityIndicatorView performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    [currentCell performSelectorOnMainThread:@selector(setAccessoryView:) withObject:nil waitUntilDone:NO];
    
    [pool drain];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[super dealloc];
	[geotagDetailViewController release];
	[apiAccessor release];    
}


@end

