//
//  ApiResponse.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiResponse : NSObject {
	
	NSDictionary *apiDict;
	
}

@property (nonatomic, retain) NSDictionary *apiDict;

- (ApiResponse *) initDict;
- (void) addToDict: (NSString *)elementName value: (NSString *)currentValue;

@end
