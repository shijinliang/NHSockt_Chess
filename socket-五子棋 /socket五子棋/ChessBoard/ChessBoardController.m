//
//  ChessBoardController.m
//  socket五子棋
//
//  Created by xiaoshi on 16/5/26.
//  Copyright © 2016年 Niu. All rights reserved.
//

#import "ChessBoardController.h"

#define appWidth    [UIScreen mainScreen].bounds.size.width
#define appHeight   [UIScreen mainScreen].bounds.size.height

@interface ChessBoardController ()

#pragma mark - 界面
@property (nonatomic, strong) UIButton *overButton;

#pragma mark - 游戏数据
/**
 *  当前下棋的个数
 */
@property (nonatomic, strong) UILabel *countLabel;

/**
 *  是否轮到自己
 */
@property (nonatomic, assign) BOOL isMe;



@end

@implementation ChessBoardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.overButton];
    self.overButton.frame = CGRectMake(appWidth - 100, 25, 80, 40);
    
    [self setOverButtonLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 私有方法

/**
 *  设置按钮的渲染
 */
- (void)setOverButtonLayer
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.overButton.bounds byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(10, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.overButton.bounds;
    maskLayer.path = path.CGPath;
    self.overButton.layer.mask = maskLayer;
}
/**
 *  结束游戏
 */
- (void)clickOverGame
{
    NSLog(@"结束游戏");
}

#pragma mark - 懒加载
- (UIButton *)overButton
{
    if (!_overButton) {
        _overButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _overButton.backgroundColor = [UIColor redColor];
        [_overButton setTitle:@"结束游戏" forState:UIControlStateNormal];
        [_overButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _overButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_overButton addTarget:self action:@selector(clickOverGame) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overButton;
}

@end
