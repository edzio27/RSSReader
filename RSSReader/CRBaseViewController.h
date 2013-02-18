//
//  CRBaseViewController.h
//  RSSReader
//
//  Created by edzio27 on 12.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

#define ALERTVIEW_ERROR_CONNECTION 111

@interface CRBaseViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UIAlertView *noInternetConnection;
@property (nonatomic, strong) UITableView *tableView;

- (BOOL)isThereInternetConnection;

@end
