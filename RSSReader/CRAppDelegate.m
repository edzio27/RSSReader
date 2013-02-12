//
//  CRAppDelegate.m
//  RSSReader
//
//  Created by edzio27 on 09.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import "CRAppDelegate.h"
#import <CoreData/CoreData.h>
#import "CRViewController.h"
#import "CRHistoryViewController.h"
#import "CRToReadArticleViewController.h"

@implementation CRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [self initTabBarController];

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initTabBarController {
    self.tabBarController = [[UITabBarController alloc] init];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    CRViewController *mainViewController = [[CRViewController alloc]initWithNibName:@"CRViewController_iPhone" bundle:nil];
    mainViewController.title = @"Main";
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [viewControllers addObject:self.navigationController];
    
    CRHistoryViewController *historyViewController = [[CRHistoryViewController alloc]initWithNibName:@"CRHistoryViewController" bundle:nil];
    historyViewController.title = @"History";
    [viewControllers addObject:historyViewController];
    
    CRToReadArticleViewController *toReadArticleViewController = [[CRToReadArticleViewController alloc]initWithNibName:@"CRToReadArticleViewController" bundle:nil
                                                                  ];
    toReadArticleViewController.title = @"To read";
    [viewControllers addObject:toReadArticleViewController];
    
    self.tabBarController.viewControllers = viewControllers;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark core data methods

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent: @"rssDatabase.sqlite"];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
    						 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
    						 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle error
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma end

@end
