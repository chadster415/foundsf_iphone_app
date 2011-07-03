//
//  ApiRequest.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ApiRequest.h"


@implementation ApiRequest

@synthesize endpoint;
@synthesize username;
@synthesize op;
@synthesize hood;
@synthesize imageurl;
@synthesize pageid;
@synthesize latcoord;
@synthesize longcoord;
@synthesize count;
@synthesize pastusernames;

-(void) dealloc{
	[endpoint release];
	[username release];
	[op release];
	[hood release];
	[imageurl release];
	[pageid release];
    [latcoord release];
	[longcoord release];
	[count release];
	[pastusernames release];
	
	[super dealloc];
}

@end
