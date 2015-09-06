//
//  ZMColorInfo.h
//  04-绘图板
//
//  Created by Arron on 15-5-1.
//  Copyright (c) 2015年 Arron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef enum {
    ColorElementRed,
    ColorElementGreen,
    ColorElementBlue,
    ColorElementAlpha
} ColorElement;

@interface ZMPathInfo : NSObject <NSMutableCopying>
/**
 *  颜色信息@[R,G,B,Alpha]
 */
@property (nonatomic, strong) NSMutableArray *colorSet;
/**
 *  画笔粗细
 */
@property (nonatomic, copy) NSString *strokeW;
///**
// *  画笔头帽
// */
//@property (nonatomic, copy) NSString *strokeCap;
///**
// *  路径转角
// */
//@property (nonatomic, copy) NSString *strokeJoin;

@end
