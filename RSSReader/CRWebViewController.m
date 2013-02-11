//
//  CRWebViewController.m
//  RSSReader
//
//  Created by edzio27 on 10.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import "CRWebViewController.h"
#import "LoadingView.h"
#import <CoreData/CoreData.h>
#import "CRAppDelegate.h"

@interface CRWebViewController ()

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CRWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)url;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.url = url;
        // Custom initialization
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        CRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if(_persistentStoreCoordinator == nil) {
        CRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _persistentStoreCoordinator = appDelegate.persistentStoreCoordinator;
    }
    return _persistentStoreCoordinator;
}

- (void)cachedWebArticle {
    NSManagedObject *failedBankInfo = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"CacheArticle"
                                       inManagedObjectContext:self.managedObjectContext];
    [failedBankInfo setValue:@"title!!" forKey:@"articleTitle"];
    [failedBankInfo setValue:@"siemka" forKey:@"articleURL"];
    [failedBankInfo setValue:@"12231234" forKey:@"articleTime"];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    self.loadingView = [LoadingView
                                loadingViewInView:self.view
                                withTitle:NSLocalizedString(@"Loading...", nil)];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:requestObj];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.loadingView removeView];
    [self cachedWebArticle];
}

@end
