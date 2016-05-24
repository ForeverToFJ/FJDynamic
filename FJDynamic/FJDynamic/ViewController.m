//
//  ViewController.m
//  FJDynamic
//
//  Created by  高帆 on 16/5/24.
//  Copyright © 2016年 GF. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UISwitch *FJswitch;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

/**
 *  物理仿真器
 */
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 懒加载
- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

#pragma mark - actions
/**
 *  重力
 */
- (IBAction)gravity {
    
    // 创建重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:self.slider];
    [gravity addItem:self.segmentedControl];
    [gravity addItem:self.progressView];
    [gravity addItem:self.FJswitch];
    [gravity addItem:self.activity];
    
    // 重力向量 -> 方向
    gravity.gravityDirection = CGVectorMake(1, 5);
    
    // 加速度 point/s²    走的距离 0.5 * magnitude * 时间²
    gravity.magnitude = 5;
    
    // 开始重力仿真
    [self.animator addBehavior:gravity];
}

/**
 *  碰撞
 */
- (IBAction)collision {
    // 创建碰撞行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    [collision addItem:self.slider];
    [collision addItem:self.segmentedControl];
    [collision addItem:self.progressView];
    [collision addItem:self.FJswitch];
    [collision addItem:self.activity];
    
    // 碰撞边界
//    collision.translatesReferenceBoundsIntoBoundary = YES;   // self.view的边框
    /*  // 线性边界
    CGFloat startX = 0;
    CGFloat startY = self.view.frame.size.height * 0.5;
    CGFloat endX = self.view.frame.size.width;
    CGFloat endY = startY * 2;
    [collision addBoundaryWithIdentifier:@"line1" fromPoint:CGPointMake(startX, startY) toPoint:CGPointMake(endX, endY)];
    [collision addBoundaryWithIdentifier:@"line2" fromPoint:CGPointMake(endX, 0) toPoint:CGPointMake(endX, endY)];
     */
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [collision addBoundaryWithIdentifier:@"circle" forPath:bezierPath];
    
    // 创建重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
//    [gravity addItem:self.slider];
//    [gravity addItem:self.segmentedControl];
//    [gravity addItem:self.progressView];
    [gravity addItem:self.FJswitch];
//    [gravity addItem:self.activity];
    
//    gravity.magnitude = 10;
    
    // 开始碰撞行为
    [self.animator addBehavior:collision];
    [self.animator addBehavior:gravity];
}

/**
 *  捕捉
 */
- (IBAction)catch {
 
    // 创建捕捉行为
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.FJswitch snapToPoint:CGPointMake(0, 0)];
    
    // 开始捕捉行为
    [self.animator addBehavior:snap];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 获取触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    // 创建捕捉行为
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.FJswitch snapToPoint:point];
    
    // 防抖系数 (越小越抖) 0 ~ 1
    snap.damping = 0.8;
    
    // 清楚之前的行为
    [self.animator removeAllBehaviors];
    
    // 开始捕捉行为
    [self.animator addBehavior:snap];
}

@end
