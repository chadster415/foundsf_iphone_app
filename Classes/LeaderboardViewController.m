//
//  LeaderboardViewController.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "APIAccessor.h"


@implementation LeaderboardViewController
@synthesize scoreDict;
@synthesize apiAccessor;
@synthesize usernamesSortedDesc;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if (apiAccessor == nil) {
		apiAccessor = [[APIAccessor alloc] init];
	}
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Calling view did appear");
    
    //do api call for top 10 users    
	self.scoreDict = [[self apiAccessor] getTopScores];	
	self.usernamesSortedDesc = [self.scoreDict keysSortedByValueUsingSelector:@selector(intCompare:)];
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.usernamesSortedDesc count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	
	//NSLog(@"Trying to access row %u", row);    
	NSString *username = [self.usernamesSortedDesc objectAtIndex: row];
	[cell.textLabel setText:username];
	[cell.detailTextLabel setText: [self.scoreDict objectForKey: username]];
	
	cell.detailTextLabel.textColor =  [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
	
	return cell;
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

@implementation NSString (numericComparison)

- (NSComparisonResult) intCompare:(NSString *) other
{
    int myValue = [self intValue];
    int otherValue = [other intValue];
    if (myValue == otherValue) return NSOrderedSame;
    return (myValue < otherValue ? NSOrderedDescending : NSOrderedAscending);
}

@end
