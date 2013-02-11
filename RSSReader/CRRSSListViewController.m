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

@interface CRRSSListViewController ()

@property (nonatomic, strong) NSMutableArray *parseResult;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

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

- (NSMutableArray *)parseResult {
    if(_parseResult == nil) {
        _parseResult = [[NSMutableArray alloc] init];
    }
    return _parseResult;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:@"http://www.capgemini.com/ctoblog/feed/" delegate:nil];
    self.parseResult = parser.posts;
    // Do any additional setup after loading the view from its nib.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSScanner *scanner = [NSScanner scannerWithString:[[self.parseResult objectAtIndex:indexPath.row] objectForKey:@"link"]];
    [scanner scanUpToString:@"?" intoString:nil]; // Scan all characters before #
    NSInteger right;
    right = [scanner scanLocation];
    
    NSString *string = [[[self.parseResult objectAtIndex:indexPath.row] objectForKey:@"link"] substringWithRange:NSMakeRange(0, right)];
    string = [string stringByReplacingOccurrencesOfString: @"\n\t\t" withString: @""];
    
    NSURL *url = [NSURL URLWithString:string];
    CRWebViewController *webViewController = [[CRWebViewController alloc] initWithNibName:@"CRWebViewController" bundle:[NSBundle mainBundle] url:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma end


@end
