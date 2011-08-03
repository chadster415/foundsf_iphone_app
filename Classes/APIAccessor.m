//
//  APIAccessor.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APIAccessor.h"
#import "XMLReader.h"
#import "ApiRequest.h"
#import "ApiResponse.h"
#import "Constants.h"
#import "DistrictImage.h"


@implementation APIAccessor
@synthesize apiRequest;

- (id)init {
	if (apiRequest == nil){
		apiRequest = [ApiRequest alloc];
	}	
	return self;
}

- (DistrictImage *) getDistrictImage: (NSString *) district {
	
	//url escape district name
	NSString *escapedDistrict = [district stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	DistrictImage *obj = [DistrictImage alloc];
	ApiResponse *apiResponse = [[ApiResponse alloc] initDict];
	XMLReader *parser = [[XMLReader alloc] initWithApiResponse:apiResponse];
	
	apiRequest.op = OP_GET;
	apiRequest.endpoint = ENDPOINT_IMAGE;
	apiRequest.hood = escapedDistrict;
    apiRequest.username = [self getCurrentlyStoredUsername];
	
	NSString *apiUrl = [self getApiUrl: apiRequest];
	DLog(@"Url is %@", apiUrl);
	[parser parse:apiUrl];
	
	NSString *pageidstring = [self trimString:[[[apiResponse.apiDict objectForKey:RESPONSE] objectForKey:PAGEID] objectForKey:TEXT]];
    obj.pageid = [pageidstring integerValue];
	obj.imageurl = [self trimString:[[[apiResponse.apiDict objectForKey:RESPONSE] objectForKey:IMAGEURL] objectForKey:TEXT]];
	obj.imagetext = [self trimString:[[[apiResponse.apiDict objectForKey:RESPONSE] objectForKey:IMAGETEXT] objectForKey:TEXT]];
	
	[parser release];
	[apiResponse release];    
	
    [obj autorelease];
	return obj;
	
}

- (void) sendCoords: (double) latitude longitude: (double) longitude district:(NSString *) district imageurl: (NSString *) imageurl pageid: (NSInteger) pageid {
    
	ApiResponse *apiResponse = [[ApiResponse alloc] initDict];
	XMLReader *parser = [[XMLReader alloc] initWithApiResponse:apiResponse];
	
	NSLog(@"sending coords in api method.....");
    //package up params in an apiRequest object
	apiRequest.endpoint = ENDPOINT_IMAGE;
	apiRequest.op = OP_TAG;
	apiRequest.imageurl = imageurl;
	apiRequest.pageid = [[NSNumber numberWithInteger:pageid] stringValue];
    district = [district stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    apiRequest.hood = district;
	apiRequest.latcoord = [[NSNumber numberWithDouble:latitude] stringValue];
    apiRequest.longcoord = [[NSNumber numberWithDouble:longitude] stringValue];
	apiRequest.username = [self getCurrentlyStoredUsername];
	
	NSString *apiUrl = [self getApiUrl: apiRequest];
	NSLog(@"Api call is %@", apiUrl);
	[parser parse:apiUrl];
	
	NSString *success = [self trimString:[[[apiResponse.apiDict objectForKey:RESPONSE] objectForKey:SUCCESS] objectForKey:TEXT]];
	NSLog(@"Success?: %@", success);
	
	[parser release];
	[apiResponse release];
	
}

- (void) skipImage: (NSString *) imageurl {
    ApiResponse *apiResponse = [[ApiResponse alloc] initDict];
	XMLReader *parser = [[XMLReader alloc] initWithApiResponse:apiResponse];
	
	NSLog(@"sending coords in api method.....");
    //package up params in an apiRequest object
	apiRequest.endpoint = ENDPOINT_IMAGE;
	apiRequest.op = OP_IGNORE;
	apiRequest.imageurl = imageurl;
	apiRequest.username = [self getCurrentlyStoredUsername];
	
	NSString *apiUrl = [self getApiUrl: apiRequest];
	NSLog(@"Api call is %@", apiUrl);
	[parser parse:apiUrl];
	
	NSString *success = [self trimString:[[[apiResponse.apiDict objectForKey:RESPONSE] objectForKey:SUCCESS] objectForKey:TEXT]];
	NSLog(@"Success?: %@", success);
	
	[parser release];
	[apiResponse release];
    
}

- (NSString *) addUser: (NSString *) username {
	ApiResponse *apiResponse = [[ApiResponse alloc] initDict];
	XMLReader *parser = [[XMLReader alloc] initWithApiResponse:apiResponse];
	
	NSLog(@"adding user in api method.....");
	apiRequest.endpoint = ENDPOINT_USER;
	apiRequest.op = OP_ADD;
	apiRequest.username = username; 
	
	NSString *apiUrl = [self getApiUrl: apiRequest];
	NSLog(@"Api call is %@", apiUrl);
	[parser parse:apiUrl];
	
	NSString *success = [self trimString:[[[apiResponse.apiDict objectForKey:RESPONSE] objectForKey:SUCCESS	] objectForKey:TEXT]];
	NSLog(@"Success?: %@", success);
	
	[parser release];
	[apiResponse release];
	
	return success;
}

- (NSString *) getUserScore {
	ApiResponse *apiResponse = [[ApiResponse alloc] initDict];
	XMLReader *parser = [[XMLReader alloc] initWithApiResponse:apiResponse];
	
	NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *usernameArray = [myDefaults objectForKey:USERNAMES];
	NSString *username = [self getCurrentlyStoredUsername];
	NSString *oldusernames = [self getOldUsernameString:usernameArray];
	
    if (username != nil){
    
        NSLog(@"getting user score in api method.....");
        apiRequest.endpoint = ENDPOINT_USER;
        apiRequest.pastusernames = oldusernames;
        apiRequest.username = username;
        apiRequest.op = nil;
        
        NSString *apiUrl = [self getApiUrl: apiRequest];
        NSLog(@"Api call is %@", apiUrl);
        [parser parse:apiUrl];
        
        NSString *score = [self trimString:[[[apiResponse.apiDict objectForKey:RESPONSE] objectForKey:SCORE] objectForKey:TEXT]];
        
        NSLog(@"Score: %@", score);
        
        [parser release];
        [apiResponse release];
        
        return score; 

    } else {
    
        [parser release];
        [apiResponse release];
        
        return @"No";
        
    }
}

- (NSString *) getCurrentNeighborhood: (double) latitude longitude: (double) longitude {
	if (latitude != 0 && longitude != 0){
        ApiResponse *apiResponse = [[ApiResponse alloc] initDict];
        XMLReader *parser = [[XMLReader alloc] initWithApiResponse:apiResponse];
        
        NSLog(@"getting district in api method....."); 
        NSMutableString *apiUrl = [[NSMutableString alloc] initWithString:NEIGHBORHOOD_API_URL];
        [apiUrl appendString:[[NSNumber numberWithDouble:latitude] stringValue]];
        [apiUrl appendString:@"&lng="];
        [apiUrl appendString:[[NSNumber numberWithDouble:longitude] stringValue]];
        
        NSLog(@"Api call is %@", apiUrl);
        [parser parse:apiUrl];
        [apiUrl release];
        
        
        NSObject *neighborhood = [[[apiResponse.apiDict objectForKey:RESULT] objectForKey:NEIGHBORHOODS] objectForKey:NEIGHBORHOOD];
        
        NSDictionary *neighborhoodElement;
        if ([neighborhood isKindOfClass:[NSDictionary class]]) {
            neighborhoodElement = (NSDictionary *)neighborhood;
        } else if ([neighborhood isKindOfClass:[NSArray class]]) {
            neighborhoodElement = [(NSArray *)neighborhood objectAtIndex: 0];
        } else { //api was empty
            neighborhoodElement = nil;
        }
        
        NSLog(@"NeighborhoodElement: %@", neighborhoodElement);
        
        NSString *neighborhoodString = @"";
        if (neighborhoodElement != nil){
            neighborhoodString = [self trimString:[[neighborhoodElement objectForKey:NAME] objectForKey:TEXT]];
        } else {
            neighborhoodString = @"Not found";
        }
        
        NSLog(@"Neighborhood: %@", neighborhoodString);
        
        [parser release];
        [apiResponse release];
        
        return neighborhoodString;
    } else {
        return @"Problem finding neighborhood. Try again.";
    }
}

- (NSDictionary *) getTopScores {
	ApiResponse *apiResponse = [[ApiResponse alloc] initDict];
	XMLReader *parser = [[XMLReader alloc] initWithApiResponse:apiResponse];
	NSMutableDictionary *scoreDict = [[NSMutableDictionary alloc] init];
	NSLog(@"getting top scores in api method.....");
	apiRequest.endpoint = ENDPOINT_USERS;
	apiRequest.op = SCORES; 
	
	NSString *apiUrl = [self getApiUrl: apiRequest];
	NSLog(@"Api call is %@", apiUrl);
	[parser parse:apiUrl];
	
	NSArray *userArray = [[[apiResponse.apiDict objectForKey:RESPONSE] objectForKey:USERS] objectForKey:USER];
	
	NSLog(@"%@",userArray);
	
	NSEnumerator *enumerator = [userArray objectEnumerator];
	id userDict;
	while ((userDict = [enumerator nextObject])) {
		NSString *username = [self trimString:[[userDict objectForKey:USERNAME] objectForKey:TEXT]];							  
		NSLog(@"%@",username);
		NSString *score = [self trimString:[[userDict objectForKey:SCORE] objectForKey:TEXT]];
		NSLog(@"%@",score);
		[scoreDict setObject:score forKey:username];
	}
    
    [parser release];
    [apiResponse release];
    [scoreDict autorelease];
		
	return scoreDict;
}

- (NSString *) getApiUrl: (ApiRequest *) req {
	
	NSMutableString *url = [[NSMutableString alloc] initWithString:MAIN_API_URL];

	[url appendString:req.endpoint];
	
	if (req.username != nil){
		if (req.op == nil || req.op == OP_ADD){
			[url appendString:@"/"];
			[url appendString:req.username];
		}
	}
	
	BOOL firstElement = TRUE;

	if (req.op != nil){
		[url appendString:[self getQSDelimiter:firstElement]];
		firstElement = FALSE;
		[url appendString:@"op="];
		[url appendString:req.op];
	}
	if (req.hood != nil){
		[url appendString:[self getQSDelimiter:firstElement]];
		firstElement = FALSE;
		[url appendString:@"hood="];
		[url appendString:req.hood];
	}
	if (req.imageurl != nil){
		[url appendString:[self getQSDelimiter:firstElement]];
		firstElement = FALSE;		
		[url appendString:@"imageurl="];
		[url appendString:req.imageurl];
	}
	if (req.pageid != nil){
		[url appendString:[self getQSDelimiter:firstElement]];
		firstElement = FALSE;		
		[url appendString:@"pageid="];
		[url appendString:req.pageid];
	}
	if (req.latcoord != nil){
		[url appendString:[self getQSDelimiter:firstElement]];
		firstElement = FALSE;		
		[url appendString:@"latcoord="];
		[url appendString:req.latcoord];
	}
    if (req.longcoord != nil){
		[url appendString:[self getQSDelimiter:firstElement]];
		firstElement = FALSE;		
		[url appendString:@"longcoord="];
		[url appendString:req.longcoord];
	}
	if (req.count != nil){
		[url appendString:[self getQSDelimiter:firstElement]];
		firstElement = FALSE;		
		[url appendString:@"count="];
		[url appendString:req.count];
	}
	if (req.pastusernames != nil){
		[url appendString:[self getQSDelimiter:firstElement]];
		//firstElement = FALSE;		
		[url appendString:@"past="];
		[url appendString:req.pastusernames];
	}
	
	if (req.username != nil){
		if (req.op == nil || req.op == OP_ADD){
			//do nothing, we've already done it above
		} else {
			[url appendString:@"&username="];
			[url appendString:req.username];
		}
	}
	
	
	//TODO: where do I [release] the url? 
	
	//NSLog(@"Concatenated url is: %@", url);
	
    [url autorelease];
    
	return url;
	
}

- (NSString *) getQSDelimiter: (BOOL) firstElement {
	if (firstElement) {
		return @"?";
	} else {
		return @"&";
	}
}

#pragma mark Stored User String Functions

- (NSString *) getOldUsernameString: (NSArray *) usernameArray {
	NSMutableString *usernameString = [[NSMutableString alloc] init];
	unsigned count = [usernameArray count];
	BOOL first = TRUE;
	while (count--) {
		if (!first){
			[usernameString appendString:@","];
		} else {
			first = FALSE;
		}
		id object = [usernameArray objectAtIndex:count];
		[usernameString appendString:(NSString *)object];
	}
	NSLog(@"username string is: %@", usernameString);
    [usernameString autorelease];
	return usernameString;
}

- (NSString *) getCurrentlyStoredUsername {
	NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *usernames = [myDefaults objectForKey:USERNAMES];
	NSString *username = [usernames objectAtIndex:[usernames count] - 1];
	NSLog(@"Current username is: %@", username);
	return username;
}

- (void) addUsernameToDefaults:(NSString *)username {
	NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *usernameArray = [myDefaults objectForKey:USERNAMES];
	NSMutableArray *mutableUsernames;
	if (usernameArray == nil){
		mutableUsernames = [[NSMutableArray alloc] init]; 
	} else {
		mutableUsernames = [[NSMutableArray alloc] initWithArray:usernameArray]; 
	}
	
	[mutableUsernames addObject:username];
	//set usernames back on NSUserDefaults
	[myDefaults setObject:mutableUsernames forKey:USERNAMES];
    
    [mutableUsernames autorelease];
	
}

- (NSString *)trimString: (NSString *)value {
	
	NSString *newValue = (NSMutableString *)[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return newValue;
}

- (void) dealloc{
	[apiRequest release];
	[super dealloc];
}
		

@end
