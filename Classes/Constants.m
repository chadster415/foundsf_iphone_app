//
//  Constants.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString * const OP_GET = @"get";
NSString * const OP_TAG = @"tag";
NSString * const OP_ADD = @"add";
NSString * const OP_IGNORE = @"ignore";
NSString * const ENDPOINT_IMAGE = @"image";
NSString * const ENDPOINT_USER = @"user";
NSString * const ENDPOINT_USERS = @"users";

NSString * const TEXT = @"text";
NSString * const SUCCESS = @"success";
NSString * const PAGEID = @"pageid";
NSString * const IMAGEURL = @"imageurl";
NSString * const IMAGETEXT = @"imagetext";
NSString * const NEIGHBORHOOD = @"neighborhood";
NSString * const NEIGHBORHOODS = @"neighborhoods";
NSString * const USERNAME = @"username";
NSString * const USERNAMES = @"usernames";
NSString * const SCORE = @"score";
NSString * const SCORES = @"scores";
NSString * const UPDATED = @"updated";
NSString * const RANK = @"rank";
NSString * const USER = @"user";
NSString * const USERS = @"users";
NSString * const NAME = @"name";
NSString * const RESPONSE = @"response";
NSString * const RESULT = @"result";

NSString * const CALCULATED_NEIGHBORHOOD = @"name";

NSString * const MAIN_API_URL = @"http://foundsf-api.appspot.com/api/";
NSString * const NEIGHBORHOOD_API_URL = @"http://api0.urbanmapping.com/neighborhoods/rest/getNeighborhoodsByLatLng?format=xml&apikey=504e24e33f634fbfeb59ea2a3bb01f1d&lat=";

@end
