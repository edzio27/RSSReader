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

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        CRAppDelegate *appDelegate = (CRAppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
