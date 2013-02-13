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

@interface CRRSSListViewController ()

@property (nonatomic, strong) NSMutableArray *parseResult;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *refreshDateLabel;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) NSMutableArray *newArticlesPost;

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

- (NSMutableArray *)newArticlesPost {
    if(_newArticlesPost == nil) {
        _newArticlesPost = [[NSMutableArray alloc] init];
    }
    return _newArticlesPost;
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
    self.newArticlesPost = nil;
    for(NSObject *post in parser.posts) {
        if(![self.parseResult containsObject:post]) {
            [self.newArticlesPost addObject:post];
        }
    }
    self.parseResult = parser.posts;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:@"http://kobieta.wp.pl/rss.xml" delegate:nil];
    self.parseResult = parser.posts;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [[self.parseResult objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.newArticlesPost.count > indexPath.row) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        CacheArticle *cacheArticle = [self arrayItemsInCoreDataWithUrl:[self getUrlAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - self.newArticlesPost.count inSection:0]]];
        if(cacheArticle) {
            //article was read
            cell.backgroundColor = [UIColor blueColor];
        }
        if(!cacheArticle) {
            cell.backgroundColor = [UIColor yellowColor];
        }
    }
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
    }
    
    NSError *error;
    if(![self.managedObjectContext save:&error]) {
        NSLog(@"Error");
    }
    CRWebViewController *webViewController = [[CRWebViewController alloc] initWithNibName:@"CRWebViewController" bundle:[NSBundle mainBundle] chacheArticle:cacheArticle];
    [self.navigationController pushViewController:webViewController animated:YES];
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
