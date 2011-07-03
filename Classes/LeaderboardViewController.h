//
//  LeaderboardViewController.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class APIAccessor;


@interface LeaderboardViewController : UITableViewController {
	NSDictionary *scoreDict;
	APIAccessor *apiAccessor;
	NSArray *usernamesSortedDesc;
}

@property (nonatomic, retain) NSDictionary *scoreDict;
@property (nonatomic, retain) APIAccessor *apiAccessor;
@property (nonatomic, retain) NSArray *usernamesSortedDesc;

@end
