//
//  CRWebViewController.h
//  RSSReader
//
//  Created by edzio27 on 10.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//  This viewController is used to show webview of current article, it inherit methods from CRBaseViewController.
//

#import <UIKit/UIKit.h>
#import "CRBaseViewController.h"

@class CacheArticle;

@interface CRWebViewController : CRBaseViewController <UIWebViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil chacheArticle:(CacheArticle *)cacheArticle;

@end
