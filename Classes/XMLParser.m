//
//  XMLParser.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import "ApiResponse.h"
#import "XMLParser.h"
#import "XMLReader.h"

@implementation XMLParser

@synthesize currentValue;
@synthesize itemElementInProgress;
@synthesize apiResponse;


// Sets the apiResponse property to a ApiResponse object passed in 
- (id)initWithApiResponse:(ApiResponse *)myApiResponse{
    if (self = [super init]) {
		[self setApiResponse:(ApiResponse *)myApiResponse];
		[self setItemElementInProgress:NO];
    }
    
    return self;
}

#pragma mark NSXMLParser Delegate Calls
// This method gets called every time NSXMLParser encounters a new element
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qualifiedName 
   attributes:(NSDictionary *)attributeDict{
    // If element is named "item", set bool to true so we know
    // we are inside the element in other methods. This is needed
    // because "item" contains most of the data we need
    if ([elementName isEqualToString:RESPONSE]) {
		[self setItemElementInProgress:YES];
    }
	
	if ( [elementName isEqualToString:USER]) {
        NSString *rank = [attributeDict objectForKey:RANK];
        if (rank)
            [[self apiResponse] setRank:rank];
	}
		  
	
}

// This method gets called for every character NSXMLParser finds.
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // If currentValue doesn't exist, initialize and allocate
    if (!currentValue) {
		currentValue = [[NSMutableString alloc] init];
    }
    
    // Append the current character value to the running string
    // that is being parsed
    [currentValue appendString:string];
}

// This method is called whenever NSXMLParser reaches the end of an element
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName{
	[self trimString];  // Remove whitespace with a convenience method
	
	//if ([elementName isEqualToString:RESPONSE]) {
		[self setItemElementInProgress:YES];  // If we are currently on the "item" element, then do not save value
	//}
	
	
	// If we are processing an element inside of "item", 
	// then determine if we need to save the value  
	if (self.itemElementInProgress) {
		// Now check the element id against the ones we are 
		// interested in (using the Constants class values).
		// If we find one, set the corresponding property on the 
		// ApiResponse object
		if ([elementName isEqualToString:SUCCESS]) {
			[[self apiResponse] setSuccess:currentValue];
		}
		if ([elementName isEqualToString:IMAGEID]) {
			[[self apiResponse] setImageid:currentValue];
		}
		if ([elementName isEqualToString:PAGEID]) {
			[[self apiResponse] setPageid:currentValue];
		}
		if ([elementName isEqualToString:IMAGEURL]) {
			[[self apiResponse] setImageurl:currentValue];
		}
		if ([elementName isEqualToString:NEIGHBORHOOD]) {
			[[self apiResponse] setNeighborhood:currentValue];
		}
		if ([elementName isEqualToString:USERNAME]) {
			[[self apiResponse] setUsername:currentValue];
		}
		if ([elementName isEqualToString:SCORE]) {
			[[self apiResponse] setScore:currentValue];
		}
		if ([elementName isEqualToString:UPDATED]) {
			[[self apiResponse] setUpdated:currentValue];
		}
		if ([elementName isEqualToString:RANK]) {
			[[self apiResponse] setRank:currentValue];
		}
		if ([elementName isEqualToString:CALCULATED_NEIGHBORHOOD]) {
			[[self apiResponse] setCalcNeighborhood:currentValue];
		}
	}
	
	[[self apiResponse] addToDict:elementName value:currentValue];
	
	
	currentValue = nil;
}

- (BOOL)parse: (NSString *) apiUrl {
    // Create and initialize an NSURL with the RSS feed address and use it to instantiate NSXMLParser
    NSURL *url = [[NSURL alloc] initWithString:apiUrl];
	NSError* error;
	NSString* urlContents = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
	
	if (urlContents){
		
		// Parse the XML into a dictionary
		NSError *parseError = nil;
		NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:urlContents error:&parseError];
		
		apiResponse.apiDict = xmlDictionary;
		
		// Print the dictionary
		NSLog(@"%@", xmlDictionary);
		
		return YES;
	} else {
		return NO;
	}	
	
	// Print the dictionary
//	NSLog(@"%@", xmlDictionary);
	
	
    //NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//	
//    // Tell NSXMLParser that this class is its delegate
//    [parser setDelegate:self];
//    
//    // Kick off file parsing
//    [parser parse];
//    
//    // Clean up
//    [url release];
//    
//    [parser setDelegate:nil];
//    [parser release];
//    return YES;
}

- (void)trimString {

	currentValue = (NSMutableString *)[currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

}	
	
	
// Make sure objects are released
- (void)dealloc {
    [currentValue release];
    [apiResponse release];
    [super dealloc];
}

@end
