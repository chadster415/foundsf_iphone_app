//
//  DistrictImage.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 3/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DistrictImage : NSObject {
	NSInteger pageid;
	NSString *imageurl;
	NSString *imagetext;
}

@property (nonatomic, assign) NSInteger pageid;
@property (nonatomic, retain) NSString *imageurl;
@property (nonatomic, retain) NSString *imagetext;

@end
