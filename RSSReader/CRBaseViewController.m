//
//  CRBaseViewController.m
//  RSSReader
//
//  Created by edzio27 on 12.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import "CRBaseViewController.h"
#import "CRAppDelegate.h"

@interface CRBaseViewController ()

@end

@implementation CRBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/* Check is there a internet connection */
- (BOOL)isThereInternetConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    return internetStatus != NotReachable ? YES : NO;
}

/* Create a tableView which we fit to the iphone screen (iphone4/iphone5) */
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 12, 296, [UIScreen mainScreen].bounds.size.height
                                                                   - self.navigationController.navigationBar.frame.size.height
                                                                   - self.tabBarController.tabBar.frame.size.height
                                                                   - 44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

/* AlertView to show user about connection problem */
- (UIAlertView *)noInternetConnection {
    if(_noInternetConnection == nil) {
        _noInternetConnection = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        _noInternetConnection.tag = ALERTVIEW_ERROR_CONNECTION;
    }
    return _noInternetConnection;
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        CRAppDelegate *appDelegate = (CRAppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (void)viewDidLoad {
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.navigationItem setTitleView:titleView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.294 green:0.553 blue:0.886 alpha:1];
}

- (void)popNavigationControllerFunction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
