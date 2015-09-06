//
//  ZMColorInfo.m
//  04-绘图板
//
//  Created by Arron on 15-5-1.
//  Copyright (c) 2015年 Arron. All rights reserved.
//

#import "ZMPathInfo.h"

@implementation ZMPathInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _colorSet = [defaults valueForKey:@"colorSet"];
        if (!_colorSet) _colorSet = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"100", nil];
        _strokeW = [defaults valueForKey:@"strokeW"];
        if (!_strokeW) _strokeW = @"8";
    }
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    ZMPathInfo *pathInfo = [[ZMPathInfo alloc] init];
    pathInfo.strokeW = [self.strokeW mutableCopy];
    pathInfo.colorSet = [[NSMutableArray alloc] initWithArray:self.colorSet copyItems:YES];
    
    return pathInfo;
}
@end
