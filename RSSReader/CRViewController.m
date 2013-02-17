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
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.navigationItem setTitleView:titleView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.294 green:0.553 blue:0.886 alpha:1];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
