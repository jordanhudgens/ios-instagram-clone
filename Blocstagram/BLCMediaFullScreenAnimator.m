//
//  BLCMediaFullScreenAnimator.m
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/22/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import "BLCMediaFullScreenAnimator.h"
#import "BLCMediaFullScreenViewController.h"

@implementation BLCMediaFullScreenAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        BLCMediaFullScreenViewController *fullScreenVC = (BLCMediaFullScreenViewController *)toViewController;
        
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = [transitionContext.containerView convertRect:self.cellImageView.bounds fromView:self.cellImageView];
        CGRect endFrame = fromViewController.view.frame;
        
        toViewController.view.frame = startFrame;
        fullScreenVC.imageView.frame = toViewController.view.bounds;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            
            fullScreenVC.view.frame = endFrame;
            [fullScreenVC centerScrollView];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        BLCMediaFullScreenViewController *fullScreenVC = (BLCMediaFullScreenViewController *)fromViewController;
        
        CGRect endFrame = [transitionContext.containerView convertRect:self.cellImageView.bounds fromView:self.cellImageView];
        CGRect imageStartFrame = [fullScreenVC.view convertRect:fullScreenVC.imageView.frame fromView:fullScreenVC.scrollView];
        CGRect imageEndFrame = [transitionContext.containerView convertRect:endFrame toView:fullScreenVC.view];
        
        imageEndFrame.origin.y = 0;
        
        [fullScreenVC.view addSubview:fullScreenVC.imageView];
        fullScreenVC.imageView.frame = imageStartFrame;
        fullScreenVC.imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        
        toViewController.view.userInteractionEnabled = YES;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fullScreenVC.view.frame = endFrame;
            fullScreenVC.imageView.frame = imageEndFrame;
            
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
