//
//  ListenManger.h
//  iOS
//
//  Created by LY_MD on 2020/6/9.
//  Copyright © 2020 LY_MD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSCPUUsage.h"
#import "FSRAMUsage.h"
#import "FSNetworkFlow.h"
#import "FSDiskUsage.h"
#include<sys/sysctl.h>
#include <sys/param.h>
#include <sys/mount.h>
NS_ASSUME_NONNULL_BEGIN

@interface ListenManger : NSObject

+ (void)startListen:(void(^)(NSDictionary *))completeBlock;

/// 上次开机时间
+ (NSString *)systemUpTime;

/// 开机后运行时间
+ (NSString *)systemRunningTime;


@end

NS_ASSUME_NONNULL_END
