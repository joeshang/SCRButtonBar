//
//  SCRButtonItem.m
//  SCRButtonBarDemo
//
//  Created by Joe Shang on 7/13/15.
//  Copyright (c) 2015 Shang Chuanren. All rights reserved.
//

#import "SCRButtonBarItem.h"

@implementation SCRButtonBarItem

#pragma mark - Life Cycle

- (instancetype)initWithCustomView:(UIView *)customView target:(id)target action:(SEL)action {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _customView = customView;
        customView.backgroundColor = [UIColor clearColor];
        [self addSubview:customView];
        
        [self addTarget:target
                 action:action
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Override Accessors

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (self.highlightedBackgroundColor) {
        self.backgroundColor = highlighted ? self.highlightedBackgroundColor : [UIColor clearColor];
    }
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.customView.frame = CGRectMake(0.f,
                                       0.f,
                                       bounds.size.width,
                                       bounds.size.height);
}

@end
