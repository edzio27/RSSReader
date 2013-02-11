//
//  CRViewController.m
//  RSSReader
//
//  Created by edzio27 on 09.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import "CRViewController.h"
#import "CRRSSListViewController.h"

@interface CRViewController ()

- (IBAction)press:(id)sender;

@end

@implementation CRViewController

- (IBAction)press:(id)sender {
    CRRSSListViewController *list = [[CRRSSListViewController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
