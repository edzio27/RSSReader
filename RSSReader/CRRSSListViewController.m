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

@interface CRRSSListViewController ()

@property (nonatomic, strong) NSMutableArray *parseResult;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *refreshDateLabel;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) NSMutableArray *newsArticle;
@property (nonatomic, weak) IBOutlet UIButton *newsArticleRefreshButton;

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

-(NSMutableArray *)newsArticle {
    if(_newsArticle == nil) {
        _newsArticle = [[NSMutableArray alloc] init];
    }
    return _newsArticle;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if(_refreshBarButtonItem == nil) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshListView)];
    }
    return _refreshBarButtonItem;
}

- (NSMutableArray *)parseResult {
    if(_parseResult == nil) {
        _parseResult = [[NSMutableArray alloc] init];
    }
    return _parseResult;
}

- (void)createRefreshDateOnLabel {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd:MM:YYYY HH:mm:ss"];
    self.refreshDateLabel.text = [dateFormat stringFromDate:date];
}

- (void)viewWillAppear:(BOOL)animated {
    if(!self.isThereInternetConnection) {
        [self.noInternetConnection show];
    } else {
        [self createRefreshDateOnLabel];
    }
    [self.tableView reloadData];
    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                                      selector: @selector(showArticleAmountToUpdate) userInfo: nil repeats: YES];
    self.newsArticleRefreshButton.hidden = YES;
    [self assignNumberOfUnreadArticle];
}

- (void)refreshListView {
    if(!self.isThereInternetConnection) {
        [self.noInternetConnection show];
    } else {
        [self loadArticlesContent];
        [self createRefreshDateOnLabel];
    }
}

- (void)loadArticlesContent {
    KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:@"http://www.capgemini.com/ctoblog/feed/" delegate:nil];
    self.parseResult = parser.posts;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadArticlesContent];
    self.navigationItem.rightBarButtonItem = self.refreshBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.backgroundColor = [UIColor blueColor];
    } else {
        cell.lastReadTimeStamp.text = [NSString stringWithFormat:@"Last read: Never"];
        cell.backgroundColor = [UIColor yellowColor];
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
        [cacheArticle setValue:[NSDate date] forKey:@"timeStamp"];
        [cacheArticle setValue:@"" forKey:@"articleContent"];
        
        [self decreaseBadgeNumber];
    }
    
    NSError *error;
    if(![self.managedObjectContext save:&error]) {
        NSLog(@"Error");
    }
    CRWebViewController *webViewController = [[CRWebViewController alloc] initWithNibName:@"CRWebViewController" bundle:[NSBundle mainBundle] chacheArticle:cacheArticle];
    [self.navigationController pushViewController:webViewController animated:YES];
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CacheArticle *cacheArticle = [self arrayItemsInCoreDataWithUrl:[self getUrlAtIndexPath:indexPath]];
    if(cacheArticle) {
        //article was read
        (CRListViewCustomCell *)cell.backgroundColor = [UIColor blueColor];
    }
    if(!cacheArticle) {
        //article wasnt read
        cell.backgroundColor = [UIColor yellowColor];
    }
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

#pragma end

#pragma mark news article

- (void)showArticleAmountToUpdate {
    dispatch_queue_t queue = dispatch_queue_create("downloadingArticles", NULL);
    dispatch_async(queue, ^{
        
        KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:@"http://www.capgemini.com/ctoblog/feed/" delegate:nil];
        self.newsArticle = parser.posts;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.newsArticle.count > self.parseResult.count) {
                self.newsArticleRefreshButton.hidden = NO;
                self.refreshBarButtonItem.title = [NSString stringWithFormat:@"%d new articles", self.newsArticle.count > self.parseResult.count];
            }
            
        });
    });
}

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

- (void)decreaseBadgeNumber {
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * numberBadge = [formatter numberFromString:self.navigationController.tabBarItem.badgeValue];
    int intBadgeValue = [numberBadge intValue];
    intBadgeValue--;
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", intBadgeValue];
}

#pragma end

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
