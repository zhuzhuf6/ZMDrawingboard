//
//  ZMColorView.m
//  ZMDrawingBoard
//
//  Created by Arron on 15-9-5.
//  Copyright (c) 2015年 Arron. All rights reserved.
//

#import "ZMColorView.h"
#import "ZMPathInfo.h"

#define kSliderH 31
#define kSliderW 250
#define kSpace 5
#define kColor(R,G,B,Alpha) [UIColor colorWithRed:R green:G blue:B alpha:Alpha]

@interface ZMColorView ()
/** 红 **/
@property (nonatomic, weak) UISlider *redSlider;
/** 绿 **/
@property (nonatomic, weak) UISlider *greenSlider;
/** 蓝 **/
@property (nonatomic, weak) UISlider *blueSlider;
/** 透明度 **/
@property (nonatomic, weak) UISlider *alphaSlider;
/** 混合色块 **/
@property (nonatomic, weak) UIButton *fixColorButton;
@end

@implementation ZMColorView
#pragma mark - 懒加载
- (UISlider *)redSlider{
    if (!_redSlider) {
        UISlider *slider = [[UISlider alloc] init];
        _redSlider = slider;
        // 设置滑动范围
        _redSlider.minimumValue = 0;
        _redSlider.maximumValue = 255;
        // 添加点击事件
        [_redSlider addTarget:self action:@selector(changeFixColor:) forControlEvents:UIControlEventValueChanged];
        // 设置tag
        _redSlider.tag = ColorElementRed;
        [self addSubview:_redSlider];
    }
    return _redSlider;
}

- (UISlider *)greenSlider{
    if (!_greenSlider) {
        UISlider *slider = [[UISlider alloc] init];
        _greenSlider = slider;
        // 设置滑动范围
        _greenSlider.minimumValue = 0;
        _greenSlider.maximumValue = 255;
        // 添加点击事件
        [_greenSlider addTarget:self action:@selector(changeFixColor:) forControlEvents:UIControlEventValueChanged];
        // 设置tag
        _greenSlider.tag = ColorElementGreen;
        [self addSubview:_greenSlider];
    }
    return _greenSlider;
}

- (UISlider *)blueSlider{
    if (!_blueSlider) {
        UISlider *slider = [[UISlider alloc] init];
        _blueSlider = slider;
        // 设置滑动范围
        _blueSlider.minimumValue = 0;
        _blueSlider.maximumValue = 255;
        // 添加点击事件
        [_blueSlider addTarget:self action:@selector(changeFixColor:) forControlEvents:UIControlEventValueChanged];
        // 设置tag
        _blueSlider.tag = ColorElementBlue;
        [self addSubview:_blueSlider];
    }
    return _blueSlider;
}

- (UISlider *)alphaSlider{
    if (!_alphaSlider) {
        UISlider *slider = [[UISlider alloc] init];
        _alphaSlider = slider;
        // 设置滑动范围
        _alphaSlider.minimumValue = 0;
        _alphaSlider.maximumValue = 100;
        // 添加点击事件
        [_alphaSlider addTarget:self action:@selector(changeFixColor:) forControlEvents:UIControlEventValueChanged];
        // 设置tag
        _alphaSlider.tag = ColorElementAlpha;
        [self addSubview:_alphaSlider];
    }
    return _alphaSlider;
}

- (UIButton *)fixColorButton{
    if (!_fixColorButton) {
        UIButton *btn = [[UIButton alloc] init];
        _fixColorButton = btn;
        [self addSubview:_fixColorButton];
    }
    return _fixColorButton;
}

#pragma mark - 方法实现
// 布局子控件
- (void)layoutSubviews{
    self.redSlider.frame = CGRectMake(kSpace, self.bounds.size.height - kSliderH * 4, kSliderW, kSliderH);
    self.greenSlider.frame = CGRectMake(kSpace, self.bounds.size.height - kSliderH * 3, kSliderW, kSliderH);
    self.blueSlider.frame = CGRectMake(kSpace, self.bounds.size.height - kSliderH * 2, kSliderW, kSliderH);
    self.alphaSlider.frame = CGRectMake(kSpace, self.bounds.size.height - kSliderH, kSliderW, kSliderH);
    self.fixColorButton.frame = CGRectMake(kSliderW + kSpace * 5, self.bounds.size.height - kSliderH * 4, kSliderW / 3, kSliderH * 4 - kSpace);
}

- (void)setPathInfo:(ZMPathInfo *)pathInfo{
    _pathInfo = pathInfo;
    
    // 加载混合颜色
    [self fixColor];
    
    // 加载滑块数据
    self.redSlider.value = [pathInfo.colorSet[ColorElementRed] floatValue];
    self.greenSlider.value = [pathInfo.colorSet[ColorElementGreen] floatValue];
    self.blueSlider.value = [pathInfo.colorSet[ColorElementBlue] floatValue];
    self.alphaSlider.value = [pathInfo.colorSet[ColorElementAlpha] floatValue];
}

- (void)changeFixColor:(UISlider *)colorSlider{
    // 保存用户设置
    self.pathInfo.colorSet[colorSlider.tag] = [NSString stringWithFormat:@"%f", colorSlider.value];
    // 调整色块颜色
    [self fixColor];

}

// 调整颜色
- (void)fixColor{
    float red = [self.pathInfo.colorSet[ColorElementRed] floatValue] / 255.0;
    float green = [self.pathInfo.colorSet[ColorElementGreen] floatValue] / 255.0;
    float blue = [self.pathInfo.colorSet[ColorElementBlue] floatValue] / 255.0;
    float alpha = [self.pathInfo.colorSet[ColorElementAlpha] floatValue] / 255.0;
    
    // 设置滑块颜色
    self.redSlider.minimumTrackTintColor = kColor(red, 0, 0, 1);
    self.greenSlider.minimumTrackTintColor = kColor(0, green, 0, 1);
    self.blueSlider.minimumTrackTintColor = kColor(0, 0, blue, 1);
    self.alphaSlider.minimumTrackTintColor = kColor(0, 0, 0, alpha);
    
    // 调整色块颜色
    [self.fixColorButton setBackgroundColor:kColor(red, green, blue, alpha)];
}
@end
