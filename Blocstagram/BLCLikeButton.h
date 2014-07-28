//
//  BLCLikeButton.h
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/28/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLCLikeState) {
    BLCLikeStateNotLiked    = 0,
    BLCLikeStateLiking      = 1,
    BLCLikeStateLiked       = 2,
    BLCLikeStateUnliking    = 3
};

@interface BLCLikeButton : UIButton

@property (nonatomic, assign) BLCLikeState likeButtonState;

@end
