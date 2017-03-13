//
//  TXHRulerScrollView.m
//  PrettyRuler
//
//  Created by GXY on 15/12/11.
//  Copyright © 2015年 Tangxianhai. All rights reserved.
//

#import "TXHRulerScrollView.h"

@implementation TXHRulerScrollView

- (void)drawRuler {
    _rulerValue = _rulerValue - _minNum;
    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.lineWidth = 0.5f;
    shapeLayer1.lineCap = kCALineCapButt;
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.lineWidth = 0.5f;
    shapeLayer2.lineCap = kCALineCapButt;
    
    for (int i = 0; i <= self.rulerCount; i++) {
        UILabel *rule = [[UILabel alloc] init];
        rule.font = [UIFont systemFontOfSize:11];
        rule.textColor = UIColorFromRGB(0xbbbbbb);
        rule.text = [NSString stringWithFormat:@"%.0f",_minNum + i * [self.rulerAverage floatValue]];
        CGSize textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];
        if (i % 10 == 0) {
            CGPathMoveToPoint(pathRef2, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , 35);
            CGPathAddLineToPoint(pathRef2, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight);
            rule.frame = CGRectMake(DISTANCELEFTANDRIGHT + DISTANCEVALUE * i - textSize.width / 2, 19, textSize.width, 11);
            [self addSubview:rule];
        }
        else
        {
            CGPathMoveToPoint(pathRef1, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , 43.5);
            CGPathAddLineToPoint(pathRef1, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight);
        }
    }
    
    shapeLayer1.path = pathRef1;
    shapeLayer2.path = pathRef2;
    
    [self.layer addSublayer:shapeLayer1];
    [self.layer addSublayer:shapeLayer2];

    // 开启最小模式
    if (_mode) {
        UIEdgeInsets edge = UIEdgeInsetsMake(0, self.rulerWidth / 2.f - DISTANCELEFTANDRIGHT, 0, self.rulerWidth / 2.f - DISTANCELEFTANDRIGHT);
        self.contentInset = edge;
        self.contentOffset = CGPointMake(DISTANCEVALUE * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth + (self.rulerWidth / 2.f + DISTANCELEFTANDRIGHT), 0);
    }
    else
    {
        self.contentOffset = CGPointMake(DISTANCEVALUE * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth / 2.f + DISTANCELEFTANDRIGHT, 0);
    }
    
    self.contentSize = CGSizeMake(self.rulerCount * DISTANCEVALUE + DISTANCELEFTANDRIGHT * 2.f, self.rulerHeight);
}

- (CGPoint )scrollViewToContentOffsetWithRulerValue:(CGFloat )rulerValue
{
     return CGPointMake(DISTANCEVALUE * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth / 2.f + DISTANCELEFTANDRIGHT, 0);
}

@end
