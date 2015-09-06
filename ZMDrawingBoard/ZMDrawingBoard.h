//
//  ZMDrawingVC.h
//  ZMDrawingBoard
//
//  Created by Arron on 15-8-29.
//  Copyright (c) 2015年 Arron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMDrawingBoard : UIViewController
/** 
 由于不知道视图的展现方式(modal或UINavigationController),取消按钮的设置不同,默认将取消按钮设置在下方的Item中,如果需要自定义就调用以下两个方法: 1,移除取消按钮 2,添加实际取消按钮的取消绘制功能;
 **/
/** 移除取消按钮 **/
- (void)removeCancelItem;
/** 取消绘制 **/
- (void)cancelDrawing;
@end
