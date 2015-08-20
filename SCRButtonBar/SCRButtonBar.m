//
//  SCRButtonBar.m
//  SCRButtonBarDemo
//
//  Created by Joe Shang on 7/13/15.
//  Copyright (c) 2015 Shang Chuanren. All rights reserved.
//

#import "SCRButtonBar.h"

#define kSeperatorDefaultColor [UIColor lightGrayColor]

static CGFloat const kSeperatorDefaultWeight = 0.5f;
static CGFloat const kVerticalSeperatorDefaultMargin = 0.0f;
static CGFloat const kHorizonalSeperatorDefaultMargin = 0.0f;

@interface SCRButtonBar ()

@property (nonatomic, strong) NSMutableArray *verticalSeperators;
@property (nonatomic, strong) NSMutableArray *horizonalSeperators;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation SCRButtonBar

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items countPerRow:(NSUInteger)countPerRow {
    self = [super initWithFrame:frame];
    
    if (!items || !items.count) {
        return nil;
    }
    
    if (self) {
        _items = [items copy];
        for (UIView *item in _items) {
            [self addSubview:item];
        }
        _countPerRow = countPerRow;
        _seperatorColor = kSeperatorDefaultColor;
        _seperatorWeight = kSeperatorDefaultWeight;
        _verticalSeperatorMargin = kVerticalSeperatorDefaultMargin;
        _horizonalSeperatorMargin = kHorizonalSeperatorDefaultMargin;
        _verticalSeperators = [[NSMutableArray alloc] init];
        _horizonalSeperators = [[NSMutableArray alloc] init];
        [self p_resetSeperator];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items {
    return [self initWithFrame:frame items:items countPerRow:items.count];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
    
    NSInteger row = [self p_totalRow];
    CGFloat seperatorWeight = ceilf(self.seperatorWeight); // 在计算位置时需要确保为整数，而在真正设置宽度时使用原值
    CGFloat contentWidth = self.bounds.size.width - self.contentInsets.left - self.contentInsets.right;
    CGFloat contentHeight = self.bounds.size.height - self.contentInsets.top - self.contentInsets.bottom;
    CGFloat buttonWidth = roundf((contentWidth - self.countPerRow * seperatorWeight) / self.countPerRow);
    CGFloat buttonHeight = roundf((contentHeight - row * seperatorWeight) / row);
    
    __block CGPoint origin = CGPointZero;
    [self.items enumerateObjectsUsingBlock:^(UIView *item, NSUInteger index, BOOL *stop){
        
        NSUInteger currentRow = index / self.countPerRow;
        NSUInteger currentColumn = index % self.countPerRow;
        origin.x = self.contentInsets.left + currentColumn * (buttonWidth + seperatorWeight);
        origin.y = self.contentInsets.top + currentRow * (buttonHeight + seperatorWeight);
        
        CGRect buttonFrame = CGRectMake(origin.x, origin.y, buttonWidth, buttonHeight);
       
        if (currentColumn != self.countPerRow - 1) {
            // 纵向分隔符
            UIView *seperator = self.verticalSeperators[currentColumn + currentRow * (self.countPerRow - 1)];
            seperator.frame = CGRectMake(origin.x + buttonWidth,
                                         origin.y + self.verticalSeperatorMargin,
                                         self.seperatorWeight,
                                         buttonHeight - 2 * self.verticalSeperatorMargin);
        } else {
            // 每行最后一个，处理由于四舍五入导致的宽度偏差
            if (origin.x + buttonWidth != contentWidth) {
                buttonFrame.size.width = contentWidth - origin.x;
            }
            
            if (currentRow != row - 1) {
                // 横向分隔符
                UIView *seperator = self.horizonalSeperators[currentRow];
                seperator.frame = CGRectMake(self.horizonalSeperatorMargin,
                                             origin.y + buttonHeight,
                                             contentWidth - 2 * self.horizonalSeperatorMargin,
                                             self.seperatorWeight);
            }
        }
     
        if (currentRow == row - 1) {
            // 最后一行，处理由于四舍五入导致的高度偏差
            if (origin.y + buttonHeight != contentHeight) {
                buttonFrame.size.height = contentHeight - origin.y;
            }
        }
        
        item.frame = buttonFrame;
    }];
}

#pragma mark - Override Accessors

- (void)setItems:(NSArray *)items {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    _items = [items copy];
    
    for (UIView *item in items) {
        [self addSubview:item];
    }
    [self p_resetSeperator];
    
    [self setNeedsLayout];
}

- (void)setCountPerRow:(NSUInteger)countPerRow {
    if (countPerRow > self.items.count) {
        countPerRow = self.items.count;
    }
    _countPerRow = countPerRow;
    
    [self p_resetSeperator];
    
    [self setNeedsLayout];
}

- (void)setSeperatorColor:(UIColor *)seperatorColor {
    for (UIView *seperator in self.verticalSeperators) {
        seperator.backgroundColor = seperatorColor;
    }
    
    for (UIView *seperator in self.horizonalSeperators) {
        seperator.backgroundColor = seperatorColor;
    }
}

- (void)setSeperatorWeight:(CGFloat)seperatorWeight {
    _seperatorWeight = seperatorWeight;
    
    [self setNeedsLayout];
}

- (void)setVerticalSeperatorMargin:(NSInteger)verticalSeperatorMargin {
    NSInteger offset = _verticalSeperatorMargin - verticalSeperatorMargin;
    _verticalSeperatorMargin = verticalSeperatorMargin;
    
    for (UIView *seperator in self.verticalSeperators) {
        CGPoint originCenter = seperator.center;
        CGRect originFrame = seperator.frame;
        originFrame.size.height += 2 * offset;
        seperator.frame = originFrame;
        seperator.center = originCenter;
    }
}

- (void)setHorizonalSeperatorMargin:(NSInteger)horizonalSeperatorMargin {
    NSInteger offset = _horizonalSeperatorMargin - horizonalSeperatorMargin;
    _horizonalSeperatorMargin = horizonalSeperatorMargin;
    
    for (UIView *seperator in self.horizonalSeperators) {
        CGPoint originCenter = seperator.center;
        CGRect originFrame = seperator.frame;
        originFrame.size.width += 2 * offset;
        seperator.frame = originFrame;
        seperator.center = originCenter;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (!self.backgroundImageView) {
        self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self insertSubview:self.backgroundImageView atIndex:0];
    } else {
        self.backgroundImageView.image = backgroundImage;
    }
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    
    [self setNeedsLayout];
}

#pragma mark - Private

- (void)p_resetSeperator {
    NSInteger row = [self p_totalRow];
    NSUInteger seperatorCount = 0;
    
    // 纵向分隔符
    for (UIView *seperator in self.verticalSeperators) {
        [seperator removeFromSuperview];
    }
    
    [self.verticalSeperators removeAllObjects];

    if (self.items.count % self.countPerRow) {
        seperatorCount = (row - 1) * (self.countPerRow - 1) + (self.items.count % self.countPerRow);
    } else {
        seperatorCount = row * (self.countPerRow - 1);
    }
    for (NSUInteger index = 0; index < seperatorCount; index++) {
        [self.verticalSeperators addObject:[self p_generateSeperator]];
    }
    
    // 横向分隔符
    for (UIView *seperator in self.horizonalSeperators) {
        [seperator removeFromSuperview];
    }
    
    [self.horizonalSeperators removeAllObjects];
    
    seperatorCount = row - 1;
    for (NSUInteger index = 0; index < seperatorCount; index++) {
        [self.horizonalSeperators addObject:[self p_generateSeperator]];
    }
}
         
- (UIView *)p_generateSeperator {
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectZero];
    seperator.backgroundColor = self.seperatorColor;
    [self addSubview:seperator];
    
    return seperator;
}

- (NSInteger)p_totalRow {
    NSInteger row = 0;
    
    if (self.items.count % self.countPerRow) {
        row = self.items.count / self.countPerRow + 1;
    } else {
        row = self.items.count / self.countPerRow;
    }
    
    return row;
}

@end
