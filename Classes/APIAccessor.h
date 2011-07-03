//
//  APIAccessor.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ApiRequest;
@class DistrictImage;

@interface APIAccessor : NSObject {
	ApiRequest *apiRequest;
}

@property (nonatomic, retain) ApiRequest *apiRequest;

- (DistrictImage *) getDistrictImage: (NSString *) district; 
- (void) sendCoords: (double) latitude longitude: (double) longitude district: (NSString *) district imageurl: (NSString *) imageurl pageid: (NSInteger) pageid;
- (void) skipImage: (NSString *) imageurl;
- (NSString *) getApiUrl: (ApiRequest *) req;
- (NSString *) addUser: (NSString *) username;
- (NSString *) getCurrentlyStoredUsername;
- (NSString *) getUserScore;
- (NSString *) getQSDelimiter: (BOOL) firstElement;
- (NSString *) getOldUsernameString: (NSArray *) usernameArray;
- (void) addUsernameToDefaults: (NSString *) username;
- (NSString *) getCurrentNeighborhood: (double) latitude longitude: (double) longitude;
- (NSDictionary *) getTopScores;
- (NSString *)trimString: (NSString *)value;

@end
