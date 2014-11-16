//
//  BLCMediaTableViewCell.h
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/11/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCMedia, BLCMediaTableViewCell, BLCComposeCommentView;

@protocol BLCMediaTableViewCellDelegate <NSObject>

- (void) cell:(BLCMediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView;
- (void) cell:(BLCMediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView;
- (void) cellDidPressLikeButton:(BLCMediaTableViewCell *)cell;
- (void) cellWillStartComposingComment:(BLCMediaTableViewCell *)cell;
- (void) cell:(BLCMediaTableViewCell *)cell didComposeComment:(NSString *)comment;

@end


@interface BLCMediaTableViewCell : UITableViewCell

@property (nonatomic, strong) BLCMedia *mediaItem;
@property (nonatomic, weak) id <BLCMediaTableViewCellDelegate> delegate;
@property (nonatomic, strong, readonly) BLCComposeCommentView *commentView;

- (BLCMedia *)mediaItem;

- (void)setMediaItem:(BLCMedia *)mediaItem;

+ (CGFloat) heightForMediaItem:(BLCMedia *)mediaItem width:(CGFloat)width;
- (void) stopComposingComment;

@end
