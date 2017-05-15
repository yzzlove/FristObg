//
//  ViewController.m
//  Start_Me_Up_New
//
//  Created by Yzz on 9/11/13.
//  Copyright (c) 2013 Yzz. All rights reserved.
//

#import "ViewController.h"
#import "math.h"

@interface ViewController ()
@property(nonatomic,strong)  UIButton *end_start;
@property(nonatomic,strong)  UIButton *btn_start;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加转盘
    UIImageView *image_disk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rank_bg.png"]];
    image_disk.frame = CGRectMake(0.0, 0.0, 320.0, 320.0);
    image1 = image_disk;
    [self.view addSubview:image1];
    
    //添加转针
    UIImageView *image_start = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_lottery_pointer.png"]];
    image_start.frame = CGRectMake(145.0, 110.0, 30, 100.0);
    image_start.layer.anchorPoint = CGPointMake(0.55, 0.8);
    image2 = image_start;
    [self.view addSubview:image2];
    
    //添加按钮
    UIButton *btn_start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn_start.frame = CGRectMake(20, 350.0, 120, 70.0);
    [btn_start setTitle:@"开始抽奖" forState:UIControlStateNormal];
    [btn_start addTarget:self action:@selector(beginThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_start];
    btn_start.enabled = YES;
    self.btn_start = btn_start;
    
    //添加按钮
    UIButton *end_start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    end_start.frame = CGRectMake(180.0, 350.0, 120.0, 70.0);
    [end_start setTitle:@"停止抽奖" forState:UIControlStateNormal];
    [end_start addTarget:self action:@selector(endThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:end_start];
    end_start.enabled = NO;
    self.end_start = end_start;
    //初始旋转单块所占角度大小
    curent_angel = M_PI*2/6;
    stopRoter = NO;
    isRankBegin = NO;
}

-(void) beginThread
{
    [self initPlace]; //默认是跳到2这个位置
    [self threadRun];
    self.btn_start.enabled = NO;
    self.end_start.enabled = YES;
}

-(void) endThread //默认停止到4这个位置
{
    stopRoter = YES;
    [self roterByPlace:4];
    self.end_start.enabled = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(stopRoter==YES&&isRankBegin==YES) //  真正的停止,提示抽奖结果
    {
        stopRoter = NO;
        isRankBegin = NO;
        UIAlertView *alertRankView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%f",[self currentRoter]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertRankView show];
        [alertRankView release];
        self.btn_start.enabled = YES;
    }
    else if(stopRoter==YES&&isRankBegin==NO) //开始真正的抽奖
    {
        isRankBegin = YES;
        [self threadRun];
    }
    else //继续旋转
    {
        [self threadRun];
    }


}

-(void) threadRun{
    //转动角度－ 初始信息
    //******************旋转动画******************
    /*关于M_PI
    #define M_PI3.14159265358979323846264338327950288
        其实它就是圆周率的值，在这里代表弧度，相当于角度制 0-360 度，M_PI=180度旋转方向为：顺时针旋转*/
    //设置动画
    spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat:Angel]];//开始转动的角度
    [spin setToValue:[NSNumber numberWithFloat:maxAngel]];
    [spin setDuration:stopRoter?2:3];//转动次数
    [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
    //速度控制器
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:stopRoter?kCAMediaTimingFunctionLinear:kCAMediaTimingFunctionLinear]];
    //添加动画
    [[image2 layer] addAnimation:spin forKey:nil];
    //锁定结束位置
    image2.transform = CGAffineTransformMakeRotation(maxAngel);
    
}
/**
 * 顺时针旋转
 * 1 = 330-30
 * 2 = 30-90
 * 3 = 90-150
 * 4 = 150-210
 * 5 = 210-270
 * 6 = 270-330
 * @param place
 * @return
 */
-(void) roterByPlace:(int) place{
    float roter = [self roteCenter:place];
    float currentRoter = [self currentRoter];
    
    //如果当前的角度小于位置的角度，则表示需要多转多少角度
    float difRoter = currentRoter - roter;
    //固定三圈360*3，后在加上当前的角度差
    maxAngel = Angel + M_PI*6 + M_PI*2-difRoter;
}

-(void) initPlace
{
    float roter = [self roteCenter:2];
    maxAngel =  roter* 200;
}
-(float) roteCenter:(int) postion
{
    //设置position
    float roter = 0.0f;
    switch (postion) {
        case 1: //角度为0 则代表为iPhone
            roter = 0;
            break;
        case 2:
            roter = curent_angel;
            break;
        case 3:
            roter = curent_angel*2;
            break;
        case 4:
            roter = curent_angel*3;
            break;
        case 5:
            roter = curent_angel*4;
            break;
        case 6:
            roter = curent_angel*5;
            break;
        default:
            roter = curent_angel*5;
            break;
    }
    return roter;
}
#pragma mark  ======= 请求后台返回的数据
/**
 * 得到转动的实际角度
 * @return
 */
-(float) currentRoter{
    int current = (int) Angel /(M_PI*2);
    if(0==current)
        return Angel;
    float roter = Angel - (M_PI*2)*current;
    return roter;
}

@end
