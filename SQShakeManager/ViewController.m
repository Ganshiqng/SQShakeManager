//
//  ViewController.m
//  SQShakeManager
//
//  Created by rvakva on 2019/3/25.
//  Copyright © 2019年 rvakva. All rights reserved.
//

#import "ViewController.h"
#import "SQShakeManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SQShakeManager SQ_SQShakeManager] setShakeManagerBlock:^{
        NSLog(@"---------------摇啊摇回调");
        //没有做多次回调判断,,所以自己做哈
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    [[SQShakeManager SQ_SQShakeManager] SQ_startAccelerometer];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[SQShakeManager SQ_SQShakeManager] SQ_stopAccelerometerUpdates];
}

@end
