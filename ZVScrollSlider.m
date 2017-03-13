//
//  ZVScrollSider.m
//  scrllSlider
//
//  Created by 子为 on 15/12/25.
//  Copyright © 2015年 wealthBank. All rights reserved.
//

#import "ZVScrollSlider.h"
#import "TXHRrettyRuler.h"

@interface ZVScrollSlider ()
<
UIScrollViewDelegate,
UITextFieldDelegate
>

@property (nonatomic, strong) UIButton         *deleteBtn;
@property (nonatomic, strong) UILabel          *titleLabel;
@property (nonatomic, strong) UIImageView      *redLine;
@property (nonatomic, strong) UIImageView      *bottomLine;
@property (nonatomic, strong) TXHRulerScrollView * rScrollView;
@property (nonatomic, assign) int              stepNum;
@property (nonatomic, assign) int              value;
@property (nonatomic, assign) BOOL             scrollByHand;

@end

@implementation ZVScrollSlider

-(instancetype)initWithFrame:(CGRect)frame minNum:(NSUInteger)minNum maxNum:(NSUInteger)maxNum rulerCount:(NSUInteger)rulerCount average:(NSInteger)average rulerValue:(NSUInteger)rulerValue
{
    if(self = [super initWithFrame:frame])
    {
        _scrollByHand = YES;
        
        //输入框
        _valueTF                          = [[UITextField alloc]initWithFrame:CGRectMake((self.frame.size.width - 160) / 2, 0, 160, 34)];
        
        _valueTF.defaultTextAttributes    = @{NSUnderlineColorAttributeName:UIColorFromRGB(0xff802c),
                                           NSUnderlineStyleAttributeName:@(NSUnderlineByWord),
                                           NSUnderlineColorAttributeName:UIColorFromRGB(0xe0e0e0),
                                           NSFontAttributeName:[UIFont systemFontOfSize:34],
                                           NSForegroundColorAttributeName:[UIColor orangeColor]};

        _valueTF.textAlignment            = NSTextAlignmentCenter;
        _valueTF.delegate                 = self;
        _valueTF.keyboardType             = UIKeyboardTypeNumberPad;
        _valueTF.placeholder              = @"1万~20万";
        
        [self addSubview:_valueTF];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 120) / 2, _valueTF.frame.origin.y + 34, 120, 1)];
        [self addSubview:view];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:view.bounds];
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(view.frame) / 2, CGRectGetHeight(view.frame))];
        [shapeLayer setFillColor:[UIColor clearColor].CGColor];
        [shapeLayer setStrokeColor:UIColorFromRGB(0xe0e0e0).CGColor];
        [shapeLayer setLineWidth:CGRectGetHeight(view.frame)];
        [shapeLayer setLineJoin:kCALineJoinRound];
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:2], nil]];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(view.frame), 0);
        [shapeLayer setPath:path];
        CGPathRelease(path);
        [view.layer addSublayer:shapeLayer];
        
        
        _redLine = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 4) / 2, CGRectGetMaxY(_valueTF.frame)+5, 4, 44)];
        _redLine.image = [UIImage imageNamed:@"zhizhen"];
        [self addSubview:_redLine];
        
        
        _rScrollView = [[TXHRulerScrollView alloc] initWithFrame:CGRectMake(0, frame.size.height - 49, self.frame.size.width, 49)];
        _rScrollView.delegate = self;
        _rScrollView.showsHorizontalScrollIndicator = NO;
        _rScrollView.rulerHeight = 49;
        _rScrollView.rulerWidth = frame.size.width;
        _rScrollView.rulerAverage = [NSNumber numberWithInteger:average];
        _rScrollView.rulerCount = rulerCount;
        _rScrollView.rulerValue = rulerValue;
        _rScrollView.mode = YES;
        _rScrollView.minNum = minNum;
        [_rScrollView drawRuler];
        _rScrollView.bounces = YES;
        [self addSubview:_rScrollView];
        
        _minNum = minNum;
        _maxNum = maxNum;
        _rulerHeight = frame.size.width;
        _average = [NSNumber numberWithInteger:average];
        _rulerCount = rulerCount;
        _rulerValue = rulerValue;
        
        _bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height - 1, self.bounds.size.width, 1)];
        _bottomLine.backgroundColor = UIColorFromRGB(0xe0e0e0);
        [self addSubview:_bottomLine];
        
        if (rulerValue > minNum) {
            _valueTF.text = [NSString stringWithFormat:@"%ld", (unsigned long)rulerValue];
        } else if (rulerValue >= minNum && rulerValue <= maxNum) {
            _valueTF.text = [NSString stringWithFormat:@"%ld", (unsigned long)rulerValue];
        } else {
            _valueTF.text = [NSString stringWithFormat:@"%ld", (unsigned long)maxNum];
        }
    }
    return self;
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _scrollByHand = NO;
    
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newStr.length <= 0) {
        _valueTF.text = @"";
        return YES;
    }
    if (newStr.length > 0 && [newStr intValue] > _maxNum)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZVScrollSliderDidTouchMax:)]) {
            [self.delegate ZVScrollSliderDidTouchMax:YES];
            _valueTF.text = [NSString stringWithFormat:@"%ld",(unsigned long)_maxNum];
            [self scrollWithRuleValue:_maxNum - _minNum];
        }
        return NO;
    } else if (newStr.length > 0 && [newStr intValue] < _minNum && [newStr intValue] > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZVScrollSlider: ValueChange:)]) {
            [self.delegate ZVScrollSliderDidTouchMin:YES];
        }
        return YES;
    } else {
        if (newStr.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ZVScrollSlider: ValueChange:)]) {
                [self.delegate ZVScrollSlider:self ValueChange:(int)[newStr intValue]];
            }
        }
        return YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self textFirldResignFirstResponder];
    _scrollByHand = YES;
}

- (void)textFirldResignFirstResponder {
    [_valueTF resignFirstResponder];
    if (_valueTF.text.length > 0 && [_valueTF.text intValue] > _maxNum) {
        _valueTF.text = [NSString stringWithFormat:@"%ld",(unsigned long)_maxNum];
        [self scrollWithRuleValue:_maxNum - _minNum];
    } else if (_valueTF.text.length > 0 && [_valueTF.text intValue] < _minNum && [_valueTF.text intValue] > 0) {
        _valueTF.text = [NSString stringWithFormat:@"%ld",(unsigned long)_minNum];
        [self scrollWithRuleValue:_minNum - _minNum];
    } else {
        if (_valueTF.text.length > 0 && [_valueTF.text intValue] > _minNum) {
            _valueTF.text = [NSString stringWithFormat:@"%d",[_valueTF.text intValue]];
            [self scrollWithRuleValue:[_valueTF.text intValue] - _minNum];
        } else {
            _valueTF.text = [NSString stringWithFormat:@"%ld",(unsigned long)_minNum];
            [self scrollWithRuleValue:_minNum - _minNum];
        }
    }
    _scrollByHand = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self textFirldResignFirstResponder];
    _scrollByHand = YES;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(TXHRulerScrollView *)scrollView
{
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    int ruleValue = (int)(offSetX / DISTANCEVALUE) * [scrollView.rulerAverage floatValue];
    if (ruleValue + _minNum <= _minNum) {
        _valueTF.text = [NSString stringWithFormat:@"%ld", (unsigned long)_minNum];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZVScrollSlider: ValueChange:)]) {
            [self.delegate ZVScrollSlider:self ValueChange:(int)_minNum];
        }
    } else if (ruleValue + _minNum >= _maxNum) {
        _valueTF.text = [NSString stringWithFormat:@"%ld", (unsigned long)_maxNum];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZVScrollSlider: ValueChange:)]) {
            [self.delegate ZVScrollSlider:self ValueChange:(int)_maxNum];
        }
    } else {
        _valueTF.text = [NSString stringWithFormat:@"%d", (int)_minNum + ruleValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZVScrollSlider: ValueChange:)]) {
            [self.delegate ZVScrollSlider:self ValueChange:(int)_minNum + ruleValue];
        }
    }
}

- (void)scrollViewDidEndDragging:(TXHRulerScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _scrollByHand = YES;
}

- (void)scrollViewDidEndDecelerating:(TXHRulerScrollView *)scrollView
{
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    NSLog(@"offSetX : %f", scrollView.contentOffset.x);
    int ruleValue = (int)(offSetX / DISTANCEVALUE) * [scrollView.rulerAverage floatValue];
    if (ruleValue + _minNum <= _minNum) {
        _valueTF.text = [NSString stringWithFormat:@"%ld", (unsigned long)_minNum];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZVScrollSlider: ValueChange:)]) {
            [self.delegate ZVScrollSlider:self ValueChange:(int)_minNum];
        }
    } else if (ruleValue + _minNum >= _maxNum) {
        _valueTF.text = [NSString stringWithFormat:@"%ld", (unsigned long)_maxNum];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZVScrollSlider: ValueChange:)]) {
            [self.delegate ZVScrollSlider:self ValueChange:(int)_maxNum];
        }
    } else {
        _valueTF.text = [NSString stringWithFormat:@"%d", (int)_minNum + ruleValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZVScrollSlider: ValueChange:)]) {
            [self.delegate ZVScrollSlider:self ValueChange:(int)_minNum + ruleValue];
        }
    }
}

- (void)scrollWithRuleValue:(NSInteger)ruleValue
{
    float sd = ruleValue / [_rScrollView.rulerAverage floatValue] * DISTANCEVALUE + DISTANCELEFTANDRIGHT - self.frame.size.width / 2;
    CGPoint ww = CGPointMake(sd , _rScrollView.contentOffset.y);
    [_rScrollView setContentOffset:ww animated:YES];
}

@end
