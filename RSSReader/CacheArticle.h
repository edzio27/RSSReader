//
//  CacheArticle.h
//  RSSReader
//
//  Created by edzio27 on 11.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CacheArticle : NSManagedObject

@property (nonatomic, retain) NSString * articleContent;
@property (nonatomic, retain) NSString * articleTitle;
@property (nonatomic, retain) NSString * articleURL;
@property (nonatomic, retain) NSDate * timeStamp;

@end
