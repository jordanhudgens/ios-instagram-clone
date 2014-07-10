//
//  BLCComment.h
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/10/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLCUser;

@interface BLCComment : NSObject

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) BLCUser *from;
@property (nonatomic, strong) NSString *text;

@end
