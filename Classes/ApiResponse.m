//
//  ApiResponse.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ApiResponse.h"


@implementation ApiResponse

@synthesize apiDict;

- (ApiResponse *) initDict {
	if (apiDict == nil){
		apiDict = [NSDictionary alloc];
	}
	return self;
}

- (void) addToDict: (NSString *)elementName value: (NSString *)currentValue {
	//if value does not exist in dict yet
	if ([apiDict objectForKey: elementName] == nil){	
		//add value to dict
		NSMutableArray *values = [NSMutableArray arrayWithObjects:currentValue, nil];
		[apiDict setValue:values forKey: elementName];
	} else {
		//add value to list of values for this key
		[[apiDict objectForKey:elementName] addObject: currentValue];
	}	
}

- (void) dealloc{
	[apiDict release];	
	[super dealloc];
}

@end
