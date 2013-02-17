//
//  CRWebViewController.m
//  RSSReader
//
//  Created by edzio27 on 10.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import "CRWebViewController.h"
#import "CacheArticle.h"
#import "LoadingView.h"

@interface CRWebViewController ()

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) CacheArticle *cacheArticle;
@property (nonatomic, strong) UIBarButtonItem *addToReadbuttonItem;
@property (nonatomic, strong) UIBarButtonItem *removeToReadbuttonItem;
@property (nonatomic, strong) LoadingView *loadingView;

@end

@implementation CRWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil chacheArticle:(CacheArticle *)cacheArticle;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cacheArticle = cacheArticle;
        // Custom initialization
    }
    return self;
}

- (void)saveCurrentContext {
    NSError *error;
    if(![self.managedObjectContext save:&error]) {
        NSLog(@"Error!");
    }
    NSLog(@"item %@", self.cacheArticle.articleToRead);
}

- (void)addToReadArticle {
    [self.cacheArticle setValue:@"1" forKey:@"articleToRead"];
    [self saveCurrentContext];
    self.navigationItem.rightBarButtonItem = self.removeToReadbuttonItem;
}

- (void)removetoReadArticle {
    [self.cacheArticle setValue:@"0" forKey:@"articleToRead"];
    [self saveCurrentContext];
    self.navigationItem.rightBarButtonItem = self.addToReadbuttonItem;
}

- (UIBarButtonItem *)addToReadbuttonItem {
    if(_addToReadbuttonItem == nil) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0, 0, 20, 20);
        [button setBackgroundImage:[UIImage imageNamed: @"edit"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addToReadArticle) forControlEvents:UIControlEventTouchUpInside];

        _addToReadbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _addToReadbuttonItem;
}

- (UIBarButtonItem *)removeToReadbuttonItem {
    if(_removeToReadbuttonItem == nil) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0, 0, 20, 20);
        [button setBackgroundImage:[UIImage imageNamed: @"edit_active"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removetoReadArticle) forControlEvents:UIControlEventTouchUpInside];
        
        _removeToReadbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _removeToReadbuttonItem;
}

- (UIBarButtonItem *)addItemToRightNavigationController {
    return [self.cacheArticle.articleToRead isEqualToString:@"1"] ? self.removeToReadbuttonItem : self.addToReadbuttonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    if(!self.isThereInternetConnection) {
        [self.loadingView removeView];
        [self.noInternetConnection show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    self.loadingView = [LoadingView
                                loadingViewInView:self.view
                                withTitle:NSLocalizedString(@"Loading...", nil)];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.cacheArticle.articleURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [self.webView loadRequest:requestObj];
    self.navigationItem.rightBarButtonItem = [self addItemToRightNavigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.loadingView removeView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == ALERTVIEW_ERROR_CONNECTION) {
        if(buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
