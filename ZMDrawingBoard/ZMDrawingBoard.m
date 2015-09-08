//
//  ZMDrawingVC.m
//  ZMDrawingBoard
//
//  Created by Arron on 15-8-29.
//  Copyright (c) 2015年 Arron. All rights reserved.
//

#import "ZMDrawingBoard.h"
#import "ZMDrawingView.h"
#import "MBProgressHUD+ZM.h"
#import "ZMPathInfo.h"
#import "ZMFontWeigthView.h"
#import "ZMColorView.h"

#define kHeight 44
#define kScorllViewH 130
#define kScreenBounds [UIScreen mainScreen].bounds

typedef enum {
    ZMAlertViewDelete,
    ZMAlertViewCancel
} ZMAlertView;

@interface ZMDrawingBoard () <UIAlertViewDelegate, ZMDrawingViewDelegate>
/** 工具条 **/
@property (nonatomic, weak) UIToolbar *toolbar;
/** 设置界面 **/
@property (nonatomic, weak) UIScrollView *settingView;
/** 画笔粗细 **/
@property (nonatomic, weak) ZMFontWeigthView *fontView;
/** 画笔颜色 **/
@property (nonatomic, weak) ZMColorView *colorView;
/** 画笔风格 **/
@property (nonatomic, weak) UIView *styleView;
/** 路径信息 **/
@property (nonatomic, strong) ZMPathInfo *pathInfo;
/** 是否保存 **/
@property (nonatomic, assign, getter=isSave) BOOL isSave;
/** 是否移除取消按钮 **/
@property (nonatomic, assign, getter=isRemove) BOOL isRemove;

@end

@implementation ZMDrawingBoard
#pragma mark - 懒加载
/** 路径信息 **/
- (ZMPathInfo *)pathInfo{
    if (!_pathInfo){
        _pathInfo = [[ZMPathInfo alloc] init];
    }
    return _pathInfo;
}
/** 工具条 **/
- (UIToolbar *)toolbar{
    if (!_toolbar) {
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        _toolbar = toolbar;
        [self.view addSubview:_toolbar];
    }
    return _toolbar;
}
/** 设置界面 **/
- (UIScrollView *)settingView
{
    if (!_settingView) {
        UIScrollView *settingView = [[UIScrollView alloc] init];
        _settingView = settingView;
        [self.view addSubview:_settingView];
    }
    return _settingView;
}

/** 画笔粗细 **/
- (ZMFontWeigthView *)fontView
{
    if (!_fontView) {
        ZMFontWeigthView *fontView = [[ZMFontWeigthView alloc] init];
        _fontView = fontView;
        [self.settingView addSubview:_fontView];
    }
    return _fontView;
}

/** 画笔颜色 **/
- (ZMColorView *)colorView
{
    if (!_colorView) {
        ZMColorView *colorView = [[ZMColorView alloc] init];
        _colorView = colorView;
        [self.settingView addSubview:_colorView];
    }
    return _colorView;
}
//
///** 画笔风格 **/
//- (UIView *)styleView
//{
//    if (!_styleView) {
//        UIView *styleView = [[UIView alloc] init];
//        _styleView = styleView;
//        [self.masking addSubview:_styleView];
//    }
//    return _styleView;
//}

#pragma mark - 方法实现
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置标题
    self.title = @"绘图板";
    
    // 将系统自带的view替换成编写好的绘图板
    ZMDrawingView *vc = [[ZMDrawingView alloc] initWithFrame:kScreenBounds];
    vc.pathInfo = self.pathInfo;
    vc.delegate = self;
    vc.backgroundColor = [UIColor whiteColor];
    [self setValue:vc forKeyPath:@"view"];
    
    // 设置toolbar
    [self setUpToolBar];
    
    // 设置子控件属性
    [self setUpSubViews];
    
}

- (void)setUpSubViews {
    // 设置界面的属性
    self.settingView.backgroundColor = [UIColor whiteColor];
    self.settingView.bounces = NO;
    self.settingView.pagingEnabled = YES;
    self.settingView.hidden = YES;
    self.settingView.showsHorizontalScrollIndicator = NO;
    self.settingView.showsVerticalScrollIndicator = NO;
    self.settingView.backgroundColor = [UIColor clearColor];
    self.settingView.frame = CGRectMake(0, kScreenBounds.size.height - kScorllViewH - kHeight, kScreenBounds.size.width, kScorllViewH);
    // 设置滚动内容大小
    self.settingView.contentSize = CGSizeMake(kScreenBounds.size.width * 3, kScorllViewH);
    
    
    // 设置子控件大小
    // 设置画笔粗细界面的位置
    self.fontView.frame = CGRectMake(0, 0, self.settingView.bounds.size.width, self.settingView.bounds.size.height);
    // 设置画笔颜色界面的位置
    self.colorView.frame = CGRectMake(self.settingView.bounds.size.width, 0, self.settingView.bounds.size.width, self.settingView.bounds.size.height);
    
    // 设置子控件内容
    self.fontView.pathInfo = self.pathInfo;
    self.colorView.pathInfo = self.pathInfo;
    
    self.fontView.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1];
    self.colorView.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1];
    
    self.isSave = YES;
}

- (void)setUpToolBar
{
    self.toolbar.frame = CGRectMake(0, kScreenBounds.size.height - kHeight, kScreenBounds.size.width, kHeight);
    
    // 增加功能按钮
    // 1.画笔粗细
    UIBarButtonItem *fontItem = [[UIBarButtonItem alloc] initWithTitle:@"Font" style:UIBarButtonItemStyleDone target:self action:@selector(showFontView)];
    // 2.画笔颜色
    UIBarButtonItem *colorItem = [[UIBarButtonItem alloc] initWithTitle:@"Color" style:UIBarButtonItemStyleDone target:self action:@selector(showColorView)];
    // 3.弹簧
    UIBarButtonItem *marginItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // 4.取消按钮
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    if (!self.isRemove) {
        cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelDrawing)];
    }
    
    // 5.弹簧
    UIBarButtonItem *marginItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // 5.保存
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveimageToPhotosAlbum)];
    saveItem.enabled = NO;
    // 6.返回一步
    UIBarButtonItem *replyItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self.view action:@selector(reply)];
    // 7.删除
    UIBarButtonItem *trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
    
    self.toolbar.items = @[fontItem, colorItem, marginItem, cancel, marginItem2, saveItem, replyItem, trashItem];
}

- (void)showFontView
{
    if (!self.settingView.hidden && !self.settingView.contentOffset.x) {
        self.settingView.hidden = YES;
        return;
    }
    self.settingView.hidden = NO;
    self.settingView.contentOffset = CGPointMake(0, 0) ;
}

- (void)showColorView
{
    if (!self.settingView.hidden && self.settingView.contentOffset.x) {
        self.settingView.hidden = YES;
        return;
    }
    self.settingView.hidden = NO;
    self.settingView.contentOffset = CGPointMake(kScreenBounds.size.width, 0) ;
    
}

- (void)delete{
    // 当用户点击删除按钮时,询问确认
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要重绘嘛~" message:@"不要手抖点错了~~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我要重绘", nil];
    alert.tag = ZMAlertViewDelete;
    [alert show];
}

// 保存图片到相册
- (void)saveimageToPhotosAlbum
{
    ZMDrawingView *drawingView = (ZMDrawingView *)self.view;
    UIImage *newImage = [drawingView saveImage];
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (UIImage *)getImage{
    return [(ZMDrawingView *)self.view saveImage];
}

// 反馈保存图片成功或者时失败
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showError:@"保存失败,请确认相册使用权限"];
    } else {
        [MBProgressHUD showSuccess:@"保存成功"];
        self.isSave = YES;
    }
}

// 取消绘制
- (void)cancelDrawing
{
    if (self.isSave) {
        // 保存绘图信息
        [self saveColorInfo];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    // 当图片未保存时提示用户是否要保存
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要退出嘛~" message:@"精心绘制的图片还未保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存并退出", @"直接退出", nil];
    alert.tag = ZMAlertViewCancel;
    [alert show];
}

/** 移除取消按钮 **/
- (void)removeCancelItem
{
    self.isRemove = YES;
}

/** 保存当前的绘图数据 **/
- (void)saveColorInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.pathInfo.colorSet forKey:@"colorSet"];
    [defaults setObject:self.pathInfo.strokeW forKey:@"strokeW"];
    [defaults synchronize];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 判断提示框类型
    if (alertView.tag == ZMAlertViewDelete) {
        if (buttonIndex) {
            ZMDrawingView *view = (ZMDrawingView *)self.view;
            [view deleteAllPath];
        }
    } else if (alertView.tag == ZMAlertViewCancel){
        if (buttonIndex == 1) {
            [self saveimageToPhotosAlbum];
        } else if (buttonIndex == 0){
            return;
        }
        [self saveColorInfo];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark - ZMDrawingViewDelegate
- (void)drawingViewBeginDraw:(ZMDrawingView *)view {
    // 开始绘图时,隐藏设置框
    self.settingView.hidden = YES;
    // 保存键可用
    UIBarButtonItem *item = self.toolbar.items[5];
    item.enabled = YES;
    // 开始绘制说明图片有改动,之前的保存状态修改为NO
    self.isSave = NO;
}
// 当所有路径清空时
- (void)drawingViewDeleteAllPath:(ZMDrawingView *)view{
    // 保存键不可用
    UIBarButtonItem *item = self.toolbar.items[5];
    item.enabled = NO;
    // 图片清空时无需保存,设定为已储存
    self.isSave = YES;
}
@end
