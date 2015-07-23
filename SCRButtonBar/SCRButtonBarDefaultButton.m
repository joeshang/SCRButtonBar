//
//  SCRButtonItem.m
//  SCRButtonBarDemo
//
//  Created by Joe Shang on 7/13/15.
//  Copyright (c) 2015 Shang Chuanren. All rights reserved.
//

#import "SCRButtonBarDefaultButton.h"

static CGFloat const kTitleIconSpacing = 6.0f;

@interface SCRButtonBarDefaultButton ()

@property (nonatomic, strong) UIImageView       *iconView;
@property (nonatomic, strong) UILabel           *titleLabel;

@end

@implementation SCRButtonBarDefaultButton

#pragma mark - Life Cycle

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _title = title;
        _icon = icon;
        _spacing = kTitleIconSpacing;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        
        _iconView = [[UIImageView alloc] init];
        _iconView.image = icon;
        [self addSubview:_iconView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithTitle:nil icon:nil];
}

- (instancetype)init {
    return [self initWithTitle:nil icon:nil];
}

#pragma mark - Override Accessors

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (self.highlightedBackgroundColor) {
        self.backgroundColor = highlighted ? self.highlightedBackgroundColor : [UIColor clearColor];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    if (title) {
        self.titleLabel.text = title;
        [self setNeedsLayout];
    }
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    
    if (icon) {
        self.iconView.image = icon;
        [self setNeedsLayout];
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    
    if (titleFont) {
        self.titleLabel.font = titleFont;
        [self setNeedsLayout];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    if (titleColor) {
        self.titleLabel.textColor = titleColor;
    }
}

- (void)setVertical:(BOOL)vertical {
    _vertical = vertical;
    
    [self setNeedsLayout];
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    
    [self setNeedsLayout];
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView sizeToFit];
    [self.titleLabel sizeToFit];
    
    CGRect iconFrame = self.iconView.bounds;
    CGRect labelFrame = self.titleLabel.bounds;
    
    if (self.vertical) {
        iconFrame.origin.x = roundf((self.bounds.size.width / 2) - (iconFrame.size.width / 2));
        labelFrame.origin.x = roundf((self.bounds.size.width / 2) - (labelFrame.size.width / 2));
        
        CGFloat verticalMargin = roundf((self.bounds.size.height - iconFrame.size.height - labelFrame.size.height - self.spacing) / 2);
        iconFrame.origin.y = verticalMargin;
        labelFrame.origin.y = verticalMargin + iconFrame.size.height + self.spacing;
        
    } else {
        iconFrame.origin.y = roundf((self.bounds.size.height / 2) - (iconFrame.size.height / 2));
        labelFrame.origin.y = roundf((self.bounds.size.height / 2) - (labelFrame.size.height / 2));
        
        CGFloat horizonalMargin = roundf((self.bounds.size.width - iconFrame.size.width - labelFrame.size.width - self.spacing) / 2);
        iconFrame.origin.x = horizonalMargin;
        labelFrame.origin.x = horizonalMargin + iconFrame.size.width + self.spacing;
    }
    
    self.iconView.frame = iconFrame;
    self.titleLabel.frame = labelFrame;
}

@end
