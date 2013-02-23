//
//  CRViewController.m
//  RSSReader
//
//  Created by edzio27 on 09.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import "CRViewController.h"
#import "CRRSSListViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CRViewController ()

@property (nonatomic, strong) UIButton *rssButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CRViewController

/* Button to load newest article */
- (void)getDataFromRSS {
    CRRSSListViewController *list = [[CRRSSListViewController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 100, 190, 100)];
        _titleLabel.font = [UIFont fontWithName:@"GillSans-LightItalic" size:20];
        _titleLabel.text = @"Try this simple rss reader.";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UIButton *)rssButton {
    if(_rssButton == nil) {
        _rssButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _rssButton.frame = CGRectMake(60, 200, 200, 40);
        [_rssButton setTitle:@"Get newest RSS article" forState:UIControlStateNormal];
        _rssButton.titleLabel.textColor = [UIColor colorWithRed:0.294 green:0.553 blue:0.886 alpha:1];
        _rssButton.backgroundColor = [UIColor whiteColor];
        
        _rssButton.layer.borderColor = [UIColor blackColor].CGColor;
        _rssButton.layer.borderWidth = 0.5f;
        _rssButton.layer.cornerRadius = 10.0f;
        
        [_rssButton addTarget:self action:@selector(getDataFromRSS) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rssButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.navigationItem setTitleView:titleView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.rssButton];
    self.view.backgroundColor = [UIColor colorWithRed:0.294 green:0.553 blue:0.886 alpha:1];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
