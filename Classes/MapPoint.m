//
//  MapPoint.m
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"


@implementation MapPoint

@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (void)dealloc
{
    [_name release];
    _name = nil;
    [_address release];
    _address = nil;    
    [super dealloc];
}

@end
