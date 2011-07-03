//
//  GeoTaggerUtilTabsAppDelegate.h
//  GeoTaggerUtilTabs
//
//  Created by Chad Armstrong on 1/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GeotagNavController;

@interface GeoTaggerUtilTabsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet UITabBarController *rootController;
	IBOutlet UINavigationController *geotagNavController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) IBOutlet UINavigationController *geotagNavController;

@end

