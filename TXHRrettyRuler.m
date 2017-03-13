//
//  TXHRrettyRuler.m
//  PrettyRuler
//
//  Created by GXY on 15/12/11.
//  Copyright © 2015年 Tangxianhai. All rights reserved.
//  withCount:(NSUInteger)count average:(NSUInteger)average

#import "TXHRrettyRuler.h"

#define SHEIGHT 8 // 中间指示器顶部闭合三角形高度
#define INDICATORCOLOR [UIColor redColor].CGColor // 中间指示器颜色

@implementation TXHRrettyRuler {
    TXHRulerScrollView * rulerScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        rulerScrollView = [self rulerScrollView];
        rulerScrollView.rulerHeight = frame.size.height;
        rulerScrollView.rulerWidth = frame.size.width;
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)showRulerScrollViewWithCount:(NSUInteger)count
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue
                           smallMode:(BOOL)mode {
    NSAssert(rulerScrollView != nil, @"***** 调用此方法前，请先调用 initWithFrame:(CGRect)frame 方法初始化对象 rulerScrollView\n");
    NSAssert(currentValue < [average floatValue] * count, @"***** currentValue 不能大于直尺最大值（count * average）\n");
    
    
    rulerScrollView.rulerAverage = average;
    rulerScrollView.rulerCount = count;
    rulerScrollView.rulerValue = currentValue;
    rulerScrollView.mode = mode;
    rulerScrollView.minNum = 10000;
    [rulerScrollView drawRuler];
    [self addSubview:rulerScrollView];
    
    
    UIImageView *redLine = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-2, self.frame.size.height - 43, 4, 43)];
    redLine.image = [UIImage imageNamed:@"zhizhen"];
    [self addSubview:redLine];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = UIColorFromRGB(0x0e0e0e);
    [self addSubview:line];
}

- (TXHRulerScrollView *)rulerScrollView {
    TXHRulerScrollView * rScrollView = [[TXHRulerScrollView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 53)];
    rScrollView.delegate = self;
    rScrollView.showsHorizontalScrollIndicator = NO;
    return rScrollView;
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com