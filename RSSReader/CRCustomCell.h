//
//  CRCustomCell.h
//  RSSReader
//
//  Created by edzio27 on 16.02.2013.
//  Copyright (c) 2013 edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRHistoryCustomCell : UITableViewCell

@property (nonatomic, strong) UILabel *updateTimeStamp;
@property (nonatomic, strong) UILabel *articleTitle;

@end

@interface CRListViewCustomCell : UITableViewCell

@property (nonatomic, strong) UILabel *lastReadTimeStamp;
@property (nonatomic, strong) UILabel *articleTitle;

@end