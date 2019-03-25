//
//  SQShakeManager.m
//  资运客户端
//
//  Created by rvakva on 2019/3/25.
//  Copyright © 2019年 甘世清. All rights reserved.
//
#define SQaccelerameter  2.3f

#import "SQShakeManager.h"
//摇一摇
#import <CoreMotion/CoreMotion.h>

static SQShakeManager * _handler;

@interface SQShakeManager()

/** 摇一摇类 */
@property (strong,nonatomic) CMMotionManager *motionManager;

@end
@implementation SQShakeManager
/**
 单例创建通知类
 
 @return return value description
 */
+(instancetype)SQ_SQShakeManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _handler = [[SQShakeManager alloc]init];
        [_handler SQ_SQShakeManager];
    });
    
    return _handler;
}

-(void)SQ_SQShakeManager
{
    _handler.motionManager = [[CMMotionManager alloc] init];//一般在viewDidLoad中进行
    _handler.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
}

//开始
-(void)SQ_startAccelerometer
{
    [_handler SQ_ViewDidAppear];
    [_handler startAccelerometer];
}
-(void)startAccelerometer
{
    //以push的方式更新并在block中接收加速度
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if (error) {
                                                     NSLog(@"motion error:%@",error);
                                                 }
                                             }];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    //综合3个方向的加速度
    double accelerameter =sqrt( pow( acceleration.x , 2 ) + pow( acceleration.y , 2 )
                               + pow( acceleration.z , 2) );
    //当综合加速度大于2.3时，就激活效果（此数值根据需求可以调整，数据越小，用户摇动的动作就越小，越容易激活，反之加大难度，但不容易误触发）
    if (accelerameter>SQaccelerameter) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_handler.ShakeManagerBlock) {
                _handler.ShakeManagerBlock();
            }
           //UI线程必须在此block内执行，例如摇一摇动画、UIAlertView之类
        });
    }
}
-(void)SQ_stopAccelerometerUpdates
{
    //停止加速仪更新（很重要！）
    [_handler.motionManager stopAccelerometerUpdates];
    [self SQ_ViewDidAppear];
}
//监听
-(void)SQ_ViewDidAppear
{
    [[NSNotificationCenter defaultCenter] addObserver:_handler
                                             selector:@selector(receiveNotification:)
                                                 name:NSExtensionHostDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_handler
                                             selector:@selector(receiveNotification:)
                                                 name:NSExtensionHostWillEnterForegroundNotification object:nil];
}
//删除
-(void)SQ_ViewDidDisappar
{
    [[NSNotificationCenter defaultCenter] removeObserver:_handler
                                                    name:NSExtensionHostDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_handler
                                                    name:NSExtensionHostWillEnterForegroundNotification object:nil];
}
//对应上面的通知中心回调的消息接收
-(void)receiveNotification:(NSNotification *)notification
{
    if ([notification.name
         isEqualToString:NSExtensionHostDidEnterBackgroundNotification])
    {
        [_handler SQ_stopAccelerometerUpdates];
    }else{
        [_handler startAccelerometer];
    }
}

@end
