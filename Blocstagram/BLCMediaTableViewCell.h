//
//  BLCMediaTableViewCell.h
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/11/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCMedia;

@interface BLCMediaTableViewCell : UITableViewCell

@property (nonatomic, strong) BLCMedia *mediaItem;

- (BLCMedia *)mediaItem;

- (void)setMediaItem:(BLCMedia *)mediaItem;

+ (CGFloat) heightForMediaItem:(BLCMedia *)mediaItem width:(CGFloat)width;

@end
