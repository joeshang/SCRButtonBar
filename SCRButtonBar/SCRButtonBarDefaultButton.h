//
//  SCRButtonItem.h
//  SCRButtonBarDemo
//
//  Created by Joe Shang on 7/13/15.
//  Copyright (c) 2015 Shang Chuanren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCRButtonBarDefaultButton : UIControl

@property (nonatomic, strong) UIImage       *icon;
@property (nonatomic, copy)   NSString      *title;
@property (nonatomic, strong) UIColor       *titleColor;
@property (nonatomic, strong) UIFont        *titleFont;
@property (nonatomic, strong) UIColor       *highlightedBackgroundColor;

@property (nonatomic, assign) CGFloat       spacing;
@property (nonatomic, assign) BOOL          vertical;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon __attribute__((objc_designated_initializer));

@end
