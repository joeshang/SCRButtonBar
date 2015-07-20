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

@end

@implementation SCRButtonBar

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items countPerRow:(NSUInteger)countPerRow {
    self = [super initWithFrame:frame];
    
    if (self) {
        _items = [items copy];
        for (UIView *item in _items) {
            [self addSubview:item];
        }
        _countPerRow = countPerRow;
        _seperatorColor = kSeperatorDefaultColor;
        _verticalSeperatorWeight = kSeperatorDefaultWeight;
        _horizonalSeperatorWeight = kSeperatorDefaultWeight;
        _verticalSeperatorMargin = kVerticalSeperatorDefaultMargin;
        _horizonalSeperatorMargin = kHorizonalSeperatorDefaultMargin;
        _verticalSeperators = [[NSMutableArray alloc] init];
        _horizonalSeperators = [[NSMutableArray alloc] init];
        [self p_resetSeperator];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items {
    return [self initWithFrame:frame items:items countPerRow:[items count]];
}

#pragma mark - Layout

- (void)layoutSubviews {
    NSInteger row = [self p_totalRow];
    CGFloat buttonWidth = roundf((self.bounds.size.width - (self.countPerRow - 1) * self.verticalSeperatorWeight) / self.countPerRow);
    CGFloat buttonHeight = roundf((self.bounds.size.height - (row - 1) * self.horizonalSeperatorWeight) / row);
    
    __block CGPoint origin = CGPointMake(0.0f, 0.0f);
    [self.items enumerateObjectsUsingBlock:^(UIView *item, NSUInteger index, BOOL *stop){
        
        NSUInteger currentRow = index / self.countPerRow;
        NSUInteger currentColumn = index % self.countPerRow;
        origin.x = currentColumn * buttonWidth;
        origin.y = currentRow * buttonHeight;
        item.frame = CGRectMake(origin.x, origin.y, buttonWidth, buttonHeight);
       
        if (currentColumn != self.countPerRow - 1) {
            // 纵向分隔符
            UIView *seperator = self.verticalSeperators[currentColumn + currentRow * (self.countPerRow - 1)];
            seperator.frame = CGRectMake(origin.x + buttonWidth,
                                         origin.y + self.verticalSeperatorMargin,
                                         self.verticalSeperatorWeight,
                                         buttonHeight - 2 * self.verticalSeperatorMargin);
        } else {
            if (currentRow != row - 1) {
                // 横向分隔符
                UIView *seperator = self.horizonalSeperators[currentRow];
                seperator.frame = CGRectMake(self.horizonalSeperatorMargin,
                                             origin.y + buttonHeight,
                                             self.bounds.size.width - 2 * self.horizonalSeperatorMargin,
                                             self.horizonalSeperatorWeight);
            }
        }
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
    if (countPerRow > [self.items count]) {
        countPerRow = [self.items count];
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

#pragma mark - Private

- (void)p_resetSeperator {
    NSInteger row = [self p_totalRow];
    NSUInteger seperatorCount = 0;
    
    // 纵向分隔符
    for (UIView *seperator in self.verticalSeperators) {
        [seperator removeFromSuperview];
    }
    
    [self.verticalSeperators removeAllObjects];

    if ([self.items count] % self.countPerRow) {
        seperatorCount = (row - 1) * (self.countPerRow - 1) + ([self.items count] % self.countPerRow);
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
    
    if ([self.items count] % self.countPerRow) {
        row = [self.items count] / self.countPerRow + 1;
    } else {
        row = [self.items count] / self.countPerRow;
    }
    
    return row;
}

@end
