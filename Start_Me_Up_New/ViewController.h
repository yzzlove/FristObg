//
//  ViewController.h
//  Start_Me_Up_New
//
//  Created by xmhouse on 9/11/13.
//  Copyright (c) 2013 xmhouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@interface ViewController : UIViewController
{
    UIImageView *image1,*image2;
    float Angel;
    float maxAngel;
    CABasicAnimation *spin;
    
    //角度－2 MP_I =360
    float curent_angel;
    BOOL stopRoter; //判断当前的是否停止
    BOOL isRankBegin; //是否是有效抽奖开始
}
@end
