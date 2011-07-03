//
//  XMLParser.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Constants; 
@class ApiResponse;  

@interface XMLParser : NSObject <NSXMLParserDelegate> {
	NSMutableString *currentValue; //This will hold element values as we build them piece by piece
	BOOL itemElementInProgress; // This will determine if we are currently parsing an element
	ApiResponse *apiResponse; // Instance of our model object
}

@property (nonatomic, retain) NSMutableString *currentValue;
@property (nonatomic, retain) ApiResponse *apiResponse;
@property BOOL itemElementInProgress;

- (BOOL)parse: (NSString *) apiUrl;
- (id)initWithApiResponse:(ApiResponse *)apiResponse; // Custom initializer
- (void) trimString; // Small convenience method to remove whitespace

@end
