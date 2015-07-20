//
//  SCRButtonItem.h
//  SCRButtonBarDemo
//
//  Created by Joe Shang on 7/13/15.
//  Copyright (c) 2015 Shang Chuanren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCRButtonBarItem : UIControl

@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic, strong) UIView  *customView;

- (instancetype)initWithCustomView:(UIView *)customView target:(id)target action:(SEL)action;

@end
