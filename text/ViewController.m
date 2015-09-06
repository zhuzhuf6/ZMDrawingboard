//
//  ViewController.m
//  text
//
//  Created by Arron on 15-9-5.
//  Copyright (c) 2015年 Arron. All rights reserved.
//

#import "ViewController.h"
#import "ZMDrawingBoard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 100) / 2, (self.view.bounds.size.height - 100) / 2, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"点我啊" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(drawVIew) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)drawVIew {
    
    ZMDrawingBoard *vc = [[ZMDrawingBoard alloc] init];
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
