//
//  GeotagTableViewController.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GeotagDetailViewController;
@class APIAccessor;


@interface GeotagTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *geotagTableView;
	NSMutableArray *districtsArray;
	GeotagDetailViewController *geotagDetailViewController;
	APIAccessor *apiAccessor;
}

@property (nonatomic, retain) NSMutableArray *districtsArray;
@property (nonatomic, retain) GeotagDetailViewController *geotagDetailViewController;
@property (nonatomic, retain) APIAccessor *apiAccessor;

@end
