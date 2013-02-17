//
//  CRCustomCell.m
//  RSSReader
//
//  Created by edzio27 on 16.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import "CRCustomCell.h"

@implementation CRHistoryCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _articleTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 30)];
        _articleTitle.backgroundColor = [UIColor clearColor];
        _articleTitle.font = [UIFont italicSystemFontOfSize:15.0f];
        [self addSubview:_articleTitle];
        
        _updateTimeStamp = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 250, 10)];
        _updateTimeStamp.backgroundColor = [UIColor clearColor];
        _updateTimeStamp.font = [UIFont italicSystemFontOfSize:11.0f];
        [self addSubview:_updateTimeStamp];
        
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

@end

@implementation CRListViewCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _articleTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 30)];
        _articleTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:_articleTitle];
        
        _lastReadTimeStamp = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 250, 10)];
        _lastReadTimeStamp.backgroundColor = [UIColor clearColor];
        [self addSubview:_lastReadTimeStamp];
        
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

@end

@implementation CRToReadViewCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _articleTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 45)];
        _articleTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:_articleTitle];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

@end