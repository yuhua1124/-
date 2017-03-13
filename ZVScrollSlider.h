//
//  ZVScrollSider.h
//  scrllSlider
//
//  Created by 子为 on 15/12/25.
//  Copyright © 2015年 wealthBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZVScrollSlider;

@protocol ZVScrollSliderDelegate <NSObject>

@optional
- (void)ZVScrollSlider:(ZVScrollSlider *)slider ValueChange:(int )value;
- (void)ZVScrollSliderDidTouchMax:(BOOL )show;
- (void)ZVScrollSliderDidTouchMin:(BOOL )show;
- (void)ZVScrollSliderDidTouchNone:(BOOL )show;
@end

@interface ZVScrollSlider : UIView
@property (nonatomic, strong) UITextField      *valueTF;
@property (nonatomic, weak) id<ZVScrollSliderDelegate> delegate;

@property (nonatomic) NSUInteger minNum;
@property (nonatomic) NSUInteger maxNum;
@property (nonatomic) NSUInteger rulerCount;
@property (nonatomic) NSUInteger rulerAverage;
@property (nonatomic) NSNumber * average;
@property (nonatomic) NSUInteger rulerHeight;
@property (nonatomic) NSUInteger rulerWidth;
@property (nonatomic) NSUInteger rulerValue;

- (instancetype)initWithFrame:(CGRect)frame minNum:(NSUInteger)minNum maxNum:(NSUInteger)maxNum rulerCount:(NSUInteger)rulerCount average:(NSInteger)average rulerValue:(NSUInteger)rulerValue;

- (void)textFirldResignFirstResponder;
@end