//
//  ZMDrawingView.m
//  ZMDrawingBoard
//
//  Created by Arron on 15-8-29.
//  Copyright (c) 2015年 Arron. All rights reserved.
//

#import "ZMDrawingView.h"
#import "ZMPathInfo.h"

#define kColor(R,G,B,Alpha) [UIColor colorWithRed:R green:G blue:B alpha:Alpha]

@interface ZMDrawingView ()
/**
 *  用来存储每一次绘图路径的数组
 */
@property (nonatomic, strong) NSMutableArray *pathArray;
/**
 *  用来存储每一次的绘图信息的路径
 */
@property (nonatomic, strong) NSMutableArray *pathInfoArray;
@end

@implementation ZMDrawingView
#pragma mark - 懒加载
- (NSMutableArray *)pathArray
{
    if (!_pathArray) {
        NSMutableArray *arrayM = [NSMutableArray array];
        _pathArray = arrayM;
    }
    return _pathArray;
}

- (NSMutableArray *)pathInfoArray
{
    if (!_pathInfoArray) {
        NSMutableArray *arrayM = [NSMutableArray array];
        _pathInfoArray = arrayM;
    }
    return _pathInfoArray;
}

#pragma mark - 触摸事件
// 触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(drawingViewBeginDraw:)]) {
        [self.delegate drawingViewBeginDraw:self];
    }
    
    UITouch *touch = [touches anyObject];
    // 设置一条路径用来存储用户每一次从touchesBegin到touchesEnd的操作
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 定位
    [path moveToPoint:[touch locationInView:touch.view]];
    // 将路径添加到数组中
    [self.pathArray addObject:path];
    // 将当前的路径信息拷贝到数组当中
    ZMPathInfo *pathInfo = [self.pathInfo mutableCopy];
    [self.pathInfoArray addObject:pathInfo];
}

// 持续触摸
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 从数组中取出最新的路径,并添加路径
    [self addNewPath:[self.pathArray lastObject] andTouch:[touches anyObject]];
}

// 触摸结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 从数组中取出最新的路径,并添加路径
    [self addNewPath:[self.pathArray lastObject] andTouch:[touches anyObject]];
}

// 给一个路径添加新的点
- (void)addNewPath:(UIBezierPath *)path andTouch:(UITouch *)touch
{
    // 增加新的点
    [path addLineToPoint:[touch locationInView:touch.view]];
    // 刷新界面
    [self setNeedsDisplay];
}

#pragma mark - 绘图
- (void)drawRect:(CGRect)rect{
    int i = 0;
    for (UIBezierPath *path in self.pathArray) {
        // 读取路径数据
        ZMPathInfo *pathInfo = self.pathInfoArray[i];
        float red = [pathInfo.colorSet[ColorElementRed] floatValue] / 255.0;
        float green = [pathInfo.colorSet[ColorElementGreen] floatValue] / 255.0;
        float blue = [pathInfo.colorSet[ColorElementBlue] floatValue] / 255.0;
        float alpha = [pathInfo.colorSet[ColorElementAlpha] floatValue] / 255.0;
        
        // 设置路径
        [path setLineWidth:[pathInfo.strokeW intValue]];
        [kColor(red, green, blue, alpha) set];
        [path stroke];
        i++;
    }
    
}

#pragma mark - 方法实现
/**
 *  返回一步
 */
- (void)reply
{
    [self.pathArray removeLastObject];
    [self.pathInfoArray removeLastObject];
    [self setNeedsDisplay];
    // 如果路径集为空就通知代理
    if (!self.pathArray.count) {
        if ([self.delegate respondsToSelector:@selector(drawingViewDeleteAllPath:)]) {
            [self.delegate drawingViewDeleteAllPath:self];
        }
    }
}
/**
 *  删除所有路径
 */
- (void)deleteAllPath
{
    [self.pathArray removeAllObjects];
    [self.pathInfoArray removeAllObjects];
    [self setNeedsDisplay];
    if ([self.delegate respondsToSelector:@selector(drawingViewDeleteAllPath:)]) {
        [self.delegate drawingViewDeleteAllPath:self];
    }
}
/**
 *  保存图片
 */
- (UIImage *)saveImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer drawInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

@end
