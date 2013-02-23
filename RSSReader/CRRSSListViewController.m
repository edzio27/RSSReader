//
//  CRRSSListViewController.m
//  RSSReader
//
//  Created by edzio27 on 09.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import "CRRSSListViewController.h"
#import "KMXMLParser.h"
#import "CRWebViewController.h"
#import "CacheArticle.h"
#import <CoreData/CoreData.h>
#import "CRAppDelegate.h"
#import "CRCustomCell.h"
#import <QuartzCore/QuartzCore.h>
#import "LoadingView.h"

/* RSS url for downloading data */
static NSString *RSS_URL = @"http://www.pl.capgemini-sdm.com/feed.rss";

@interface CRRSSListViewController ()

@property (nonatomic, strong) NSMutableArray *parseResult;
@property (nonatomic, weak) IBOutlet UILabel *refreshDateLabel;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) NSMutableArray *newsArticle;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) LoadingView *loadingView;

@end

@implementation CRRSSListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/* Create a view where we inform user about new articles */
- (UIView *)headerView {
    if(_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 296, 40)];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 296, 40)];
        [button addTarget:self action:@selector(refreshListView) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitle:@"New articles, refresh content!" forState:UIControlStateNormal];
        [_headerView addSubview:button];
    }
    return _headerView;
}

/* Alloc a array with newest article */
-(NSMutableArray *)newsArticle {
    if(_newsArticle == nil) {
        _newsArticle = [[NSMutableArray alloc] init];
    }
    return _newsArticle;
}

/* Create a refresh button to load actual articles */
- (UIBarButtonItem *)refreshBarButtonItem {
    if(_refreshBarButtonItem == nil) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshListView)];
    }
    return _refreshBarButtonItem;
}

/* Alloc parse array */
- (NSMutableArray *)parseResult {
    if(_parseResult == nil) {
        _parseResult = [[NSMutableArray alloc] init];
    }
    return _parseResult;
}

/* Label with last date of refresh content */
- (void)createRefreshDateOnLabel {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd:MM:YYYY HH:mm:ss"];
    self.refreshDateLabel.text = [dateFormat stringFromDate:date];
}

#pragma mark view methods

- (void)viewWillAppear:(BOOL)animated {
    if(!self.isThereInternetConnection) {
        [self.noInternetConnection show];
    } else {
        [self createRefreshDateOnLabel];
    }
    [self.tableView reloadData];
    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                                      selector: @selector(showArticleAmountToUpdate) userInfo: nil repeats: YES];
    [self assignNumberOfUnreadArticle];
    [self.tableView setTableHeaderView:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.layer.cornerRadius = 3.0;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [refreshButton setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshListView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popNavigationControllerFunction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self loadFirstViewArticles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma end

- (void)refreshListView {
    [self.tableView setTableHeaderView:nil];
    if(!self.isThereInternetConnection) {
        [self.noInternetConnection show];
    } else {
        [self loadFirstViewArticles];
        [self createRefreshDateOnLabel];
    }
}

#pragma mark tableview delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.parseResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    CRListViewCustomCell *cell = (CRListViewCustomCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil) {
        cell = [[CRListViewCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    CacheArticle *cacheArticle = [self arrayItemsInCoreDataWithUrl:[self getUrlAtIndexPath:indexPath]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.articleTitle.text = [[self.parseResult objectAtIndex:indexPath.row] objectForKey:@"title"];
    if(cacheArticle) {
        cell.lastReadTimeStamp.text = [NSString stringWithFormat:@"Last read: %@", cacheArticle.timeStamp];
        cell.lastReadTimeStamp.font = [UIFont italicSystemFontOfSize:11.0f];
        cell.articleTitle.font = [UIFont italicSystemFontOfSize:15.0f];
    } else {
        cell.lastReadTimeStamp.text = [NSString stringWithFormat:@"Last read: Never"];
        cell.articleTitle.font = [UIFont boldSystemFontOfSize:15.0f];
        cell.lastReadTimeStamp.font = [UIFont boldSystemFontOfSize:11.0f];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *url = [self getUrlAtIndexPath:indexPath];
    CacheArticle *cacheArticle = [self arrayItemsInCoreDataWithUrl:url];
    if(!cacheArticle) {
        cacheArticle = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"CacheArticle"
                                       inManagedObjectContext:self.managedObjectContext];
        [cacheArticle setValue:url forKey:@"articleURL"];
        [cacheArticle setValue:[[self.parseResult objectAtIndex:indexPath.row] objectForKey:@"title"] forKey:@"articleTitle"];
        [cacheArticle setValue:@"" forKey:@"articleContent"];

        [self decreaseBadgeNumber];
    }
    [cacheArticle setValue:[NSDate date] forKey:@"timeStamp"];
    
    NSError *error;
    if(![self.managedObjectContext save:&error]) {
        NSLog(@"Error");
    }
    CRWebViewController *webViewController = [[CRWebViewController alloc] initWithNibName:@"CRWebViewController" bundle:[NSBundle mainBundle] chacheArticle:cacheArticle];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

/* Animate while adding a label about unread articles */
- (void)addTableViewHeaderWithAnimation {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         [self.tableView setTableHeaderView:self.headerView];
                     }
                     completion:nil];
}

#pragma end

#pragma mark news article

/* Download new articles asynchronously */
- (void)showArticleAmountToUpdate {
    dispatch_queue_t queue = dispatch_queue_create("downloadingArticles", NULL);
    dispatch_async(queue, ^{
        
        KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:RSS_URL delegate:nil];
        self.newsArticle = parser.posts;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(![self.newsArticle isEqualToArray:self.parseResult]) {
                [self addTableViewHeaderWithAnimation];
            };
        });
    });
}

/* Indicator while downloading aricles */
- (void)loadFirstViewArticles {
    self.loadingView = [LoadingView
                        loadingViewInView:self.view
                        withTitle:NSLocalizedString(@"Loading...", nil)];
    
    dispatch_queue_t queue = dispatch_queue_create("downloadingArticles", NULL);
    dispatch_async(queue, ^{
        
        KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:RSS_URL delegate:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView removeView];
            self.parseResult = parser.posts;
            [self.tableView reloadData];
            [self assignNumberOfUnreadArticle];
        });
    });
}

/* Make a badge about amount of unread articles */
- (void)assignNumberOfUnreadArticle {
    
    NSInteger badgePath = 0;
    for(int i = 0; i < self.parseResult.count; i++) {
        CacheArticle *cacheArticle = [self arrayItemsInCoreDataWithUrl:[self getUrlAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
        if(!cacheArticle) {
            badgePath++;
        }
    }
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", badgePath];
}

/* Decrease amount of unread articles */
- (void)decreaseBadgeNumber {
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * numberBadge = [formatter numberFromString:self.navigationController.tabBarItem.badgeValue];
    int intBadgeValue = [numberBadge intValue];
    intBadgeValue--;
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", intBadgeValue];
}

#pragma end

/* Method which return a bool value about read/unread articles */
- (CacheArticle *)arrayItemsInCoreDataWithUrl:(NSString *)url {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CacheArticle" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleURL = %@", url];
    [request setEntity:entity];
    [request setPredicate:predicate];

    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    return array.count == 0 ? nil : [array objectAtIndex:0];
}

/* Method which we use to get a url from article */
- (NSString *)getUrlAtIndexPath:(NSIndexPath *)indexPath {
    NSScanner *scanner = [NSScanner scannerWithString:[[self.parseResult objectAtIndex:indexPath.row] objectForKey:@"link"]];
    [scanner scanUpToString:@"?" intoString:nil]; // Scan all characters before #
    NSInteger right;
    right = [scanner scanLocation];
    NSString *url = [[[self.parseResult objectAtIndex:indexPath.row] objectForKey:@"link"] substringWithRange:NSMakeRange(0, right)];
    url = [url stringByReplacingOccurrencesOfString: @"\n\t\t" withString: @""];
    return url;
}

@end
