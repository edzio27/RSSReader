//
//  CRAppDelegate.h
//  RSSReader
//
//  Created by edzio27 on 09.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRViewController;

@interface CRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CRViewController *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
