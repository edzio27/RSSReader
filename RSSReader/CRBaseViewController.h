//
//  CRBaseViewController.h
//  RSSReader
//
//  Created by edzio27 on 12.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface CRBaseViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UIAlertView *noInternetConnection;

- (BOOL)isThereInternetConnection;

@end
