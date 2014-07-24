//
//  BLCMediaHelper.h
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/24/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BLCMedia.h"

@interface BLCMediaHelper : NSObject

+ (void) mediaItemToShare:(UIViewController*) viewController withMedia:(BLCMedia*)media;
@end
