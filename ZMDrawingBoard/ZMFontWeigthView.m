//
//  ZMFontWeigthView.m
//  ZMDrawingBoard
//
//  Created by Arron on 15-9-5.
//  Copyright (c) 2015年 Arron. All rights reserved.
//

#import "ZMFontWeigthView.h"
#import "ZMPathInfo.h"

#define kHeight 44
#define kSpace 5

@interface ZMFontWeigthView ()
@property (nonatomic, weak) UISlider *slider;
@property (nonatomic, weak) UILabel *label;
@end

@implementation ZMFontWeigthView
#pragma mark - 懒加载
- (UISlider *)slider
{
    if (!_slider) {
        UISlider *slider = [[UISlider alloc] init];
        _slider = slider;
        // 设置滑动范围
        _slider.minimumValue = 1;
        _slider.maximumValue = 30;
        // 初始化滑块的值
        _slider.value = [self.pathInfo.strokeW floatValue];
        // 监听值的变化
        [_slider addTarget:self action:@selector(changeStrokeW:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_slider];
    }
    return _slider;
}

- (UILabel *)label
{
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        _label = label;
        [self addSubview:_label];
    }
    return _label;
}

#pragma mark - 方法实现
- (void)changeStrokeW:(UISlider *)slider {
    self.pathInfo.strokeW = [NSString stringWithFormat:@"%ld", (NSInteger)slider.value];
    [self.label setText:self.pathInfo.strokeW];
}

// 重写set方法
- (void)setPathInfo:(ZMPathInfo *)pathInfo
{
    _pathInfo = pathInfo;
    
    // 设置初始数据
    self.slider.value = [pathInfo.strokeW integerValue];
    [self.label setText:pathInfo.strokeW];
    
}

- (void)layoutSubviews {
    // 31为滑条的默认高度,280为自定义的长度
    self.slider.frame = CGRectMake(kSpace, (self.bounds.size.height - 31) / 2, 280, 31);
    self.label.frame = CGRectMake(self.bounds.size.width - 35 -kSpace, self.slider.frame.origin.y, 40, 31);
}

@end
