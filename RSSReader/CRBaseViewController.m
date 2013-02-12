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

- (BOOL)isThereInternetConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    return internetStatus != NotReachable ? YES : NO;
}

- (UIAlertView *)noInternetConnection {
    if(_noInternetConnection == nil) {
        _noInternetConnection = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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

@end
