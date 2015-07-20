//
//  ViewController.m
//  SCRButtonBarDemo
//
//  Created by Joe Shang on 7/13/15.
//  Copyright (c) 2015 Shang Chuanren. All rights reserved.
//

#import "ViewController.h"
#import "SCRButtonBar.h"
#import "SCRButtonBarDefaultButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger buttonCount = 6;
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:buttonCount];
    for (NSInteger index = 0; index < buttonCount; index++) {
        SCRButtonBarDefaultButton *button = [[SCRButtonBarDefaultButton alloc]
                                             initWithTitle:[NSString stringWithFormat:@"测试%@", @(index)]
                                             icon:[UIImage imageNamed:@"icon"]];
                                             
        button.highlightedBackgroundColor = [UIColor lightGrayColor];
        button.vertical = YES;
        button.tag = index;
        [button addTarget:self
                   action:@selector(onButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        [items addObject:button];
    }
    
    CGRect buttonBarFrame = CGRectMake(0.0f, 40.0f, self.view.bounds.size.width, 160.0f);
    SCRButtonBar *buttonBar = [[SCRButtonBar alloc] initWithFrame:buttonBarFrame
                                                            items:items];
    buttonBar.countPerRow = 4;
    buttonBar.verticalSeperatorMargin = 10;
    buttonBar.horizonalSeperatorMargin = 5;
    buttonBar.backgroundColor = [UIColor redColor];
    [self.view addSubview:buttonBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onButtonClicked:(id)control {
    UIButton *button = (UIButton *)control;
    NSLog(@"按钮%@发生点击", @(button.tag));
}

@end
