//
//  CRHistoryViewController.m
//  RSSReader
//
//  Created by edzio27 on 11.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import "CRHistoryViewController.h"
#import <CoreData/CoreData.h>
#import "CRAppDelegate.h"
#import "CacheArticle.h"
#import "CRWebViewController.h"
#import "CRCustomCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CRHistoryViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *historyArray;

@end

@implementation CRHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.layer.cornerRadius = 3.0;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.historyArray = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)historyArray {
    if(_historyArray == nil) {
        _historyArray = [[NSMutableArray alloc] init];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"CacheArticle" inManagedObjectContext:self.managedObjectContext];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
        
        NSError *error;
        _historyArray = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    }
    return _historyArray;
}


#pragma mark tableview delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.historyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    CRHistoryCustomCell *cell = (CRHistoryCustomCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil) {
        cell = [[CRHistoryCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    CacheArticle *cacheArticle = [self.historyArray objectAtIndex:indexPath.row];
    cell.articleTitle.text = cacheArticle.articleTitle;
    cell.updateTimeStamp.text = [NSString stringWithFormat:@"Last read: %@", cacheArticle.timeStamp];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRWebViewController *webViewController = [[CRWebViewController alloc] initWithNibName:@"CRWebViewController" bundle:[NSBundle mainBundle] chacheArticle:[self.historyArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

#pragma end

@end
