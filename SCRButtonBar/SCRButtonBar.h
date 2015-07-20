//
//  SCRButtonBar.h
//  SCRButtonBarDemo
//
//  Created by Joe Shang on 7/13/15.
//  Copyright (c) 2015 Shang Chuanren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCRButtonBar : UIView

@property (nonatomic, copy)   NSArray       *items;
@property (nonatomic, assign) NSUInteger    countPerRow;

@property (nonatomic, strong) UIImage       *backgroundImage;
@property (nonatomic, assign) UIEdgeInsets  contentInsets;

@property (nonatomic, strong) UIColor       *seperatorColor;
@property (nonatomic, assign) CGFloat       verticalSeperatorWeight;
@property (nonatomic, assign) CGFloat       horizonalSeperatorWeight;
@property (nonatomic, assign) NSInteger     verticalSeperatorMargin;
@property (nonatomic, assign) NSInteger     horizonalSeperatorMargin;

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray *)items
                  countPerRow:(NSUInteger)countPerRow __attribute__((objc_designated_initializer));

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray *)items;

- (instancetype)init __attribute__((unavailable("Invoke the designated initializer")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("Invoke the designated initializer")));

@end
