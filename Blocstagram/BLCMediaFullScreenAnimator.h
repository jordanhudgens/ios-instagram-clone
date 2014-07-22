//
//  BLCMediaFullScreenAnimator.h
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/22/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLCMediaFullScreenAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, weak) UIImageView *cellImageView;

@end
