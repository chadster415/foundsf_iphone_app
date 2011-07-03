//
//  ApiRequest.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiRequest : NSObject {
	
	NSString *endpoint;
	NSString *username;
	NSString *op;
	NSString *hood;
	NSString *imageurl;
	NSString *pageid;
    NSString *latcoord;
	NSString *longcoord;
	NSString *count;
	NSString *pastusernames;
}

@property (nonatomic, assign) NSString *endpoint; 
@property (nonatomic, assign) NSString *username; 
@property (nonatomic, retain) NSString *op;
@property (nonatomic, retain) NSString *hood;
@property (nonatomic, retain) NSString *imageurl;
@property (nonatomic, retain) NSString *pageid;
@property (nonatomic, retain) NSString *latcoord;
@property (nonatomic, retain) NSString *longcoord;
@property (nonatomic, retain) NSString *count;
@property (nonatomic, retain) NSString *pastusernames;

@end
