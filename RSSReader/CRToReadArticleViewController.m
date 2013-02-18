//
//  CRToReadArticleViewController.m
//  RSSReader
//
//  Created by edzio27 on 12.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import "CRToReadArticleViewController.h"
#import "CacheArticle.h"
#import "CRWebViewController.h"
#import "CRCustomCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CRToReadArticleViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *fetchedArray;
           
@end

@implementation CRToReadArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.layer.cornerRadius = 3.0;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)fetchedArray {
    if(_fetchedArray == nil) {
        _fetchedArray = [[NSMutableArray alloc] init];
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CacheArticle" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleToRead = 1"];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    _fetchedArray = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    return _fetchedArray;
}

#pragma mark tableview delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    CRToReadViewCustomCell *cell = (CRToReadViewCustomCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil) {
        cell = [[CRToReadViewCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    CacheArticle *cacheArticle = [self.fetchedArray objectAtIndex:indexPath.row];
    cell.articleTitle.text = cacheArticle.articleTitle;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CacheArticle *cacheArticle = [self.fetchedArray objectAtIndex:indexPath.row];
    [cacheArticle setValue:[NSDate date] forKey:@"timeStamp"];
    
    NSError *error;
    if(![self.managedObjectContext save:&error]) {
        NSLog(@"Error");
    }
    
    CRWebViewController *webViewController = [[CRWebViewController alloc] initWithNibName:@"CRWebViewController" bundle:nil chacheArticle:[self.fetchedArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma end

@end
