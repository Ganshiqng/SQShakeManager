//
//  SQShakeManager.h
//  资运客户端
//
//  Created by rvakva on 2019/3/25.
//  Copyright © 2019年 甘世清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^GetSQShakeManagerBlock)(void);

@interface SQShakeManager : NSObject
//摇一摇回调
@property (copy,nonatomic)GetSQShakeManagerBlock ShakeManagerBlock;
/**
 单例创建通知类
 
 @return return value description
 */
+(instancetype)SQ_SQShakeManager;

/** 开始摇一摇 */
-(void)SQ_startAccelerometer;

/** 结束 */
-(void)SQ_stopAccelerometerUpdates;
@end

NS_ASSUME_NONNULL_END
