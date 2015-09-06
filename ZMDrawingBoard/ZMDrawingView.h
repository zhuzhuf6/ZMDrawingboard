//
//  ZMDrawingView.h
//  ZMDrawingBoard
//
//  Created by Arron on 15-8-29.
//  Copyright (c) 2015年 Arron. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZMPathInfo,ZMDrawingView;

@protocol ZMDrawingViewDelegate <NSObject>

@optional
// 开始绘制
- (void)drawingViewBeginDraw:(ZMDrawingView *)view;
// 绘图界面所有的路径都被清除了
- (void)drawingViewDeleteAllPath:(ZMDrawingView *)view;

@end

@interface ZMDrawingView : UIView
@property (nonatomic, strong) ZMPathInfo *pathInfo;

@property (nonatomic, weak) id<ZMDrawingViewDelegate> delegate;
/**
 *  当点击返回一步时,清除最后一条路径
 */
- (void)reply;
/**
 *  删除所有路径
 */
- (void)deleteAllPath;
/**
 *  保存图片
 */
- (UIImage *)saveImage;
@end
