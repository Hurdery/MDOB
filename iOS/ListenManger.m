//
//  ListenManger.m
//  iOS
//
//  Created by LY_MD on 2020/6/9.
//  Copyright © 2020 LY_MD. All rights reserved.
//

#import "ListenManger.h"

#define iS_KB_Unit(x) [NSString stringWithFormat:@"%.2fkB", (x/1024.0)]
#define iS_KB_Speed_Unit(x) [NSString stringWithFormat:@"%.2fkB/s", (x/1024.0)]
#define iS_MB_Unit(x) [NSString stringWithFormat:@"%.2fMB", (x/1024.0/1024.0)]
#define iS_GB_Unit(x) [NSString stringWithFormat:@"%.2fGB", (x/1024.0/1024.0/1024.0)]
#define iS_Percent_Unit(x) [NSString stringWithFormat:@"%.2f%%", x]
#define iS_MA_Unit(x) [NSString stringWithFormat:@"%.0fMA", (x/1.0)]


@implementation ListenManger

fs_flow_IOBytes tempNetworkFlow;
+ (void)startListen:(void(^)(NSDictionary *))completeBlock {

    // CPU
    fs_system_cpu_usage system_cpu_usage = [FSCPUUsage getSystemCPUUsageStruct];

    // RAM
    fs_system_ram_usage system_ram_usage = [FSRAMUsage getSystemRamUsageStruct];

    // NetworkFlow
    fs_flow_IOBytes networkFlow = [FSNetworkFlow getFlowIOBytes];
    
    // disk
    unsigned long long diskUsedSize = [FSDiskUsage getDiskUsedSize];
    unsigned long long diskFreeSize = [FSDiskUsage getDiskFreeSize];
    unsigned long long diskAllSize = [FSDiskUsage getDiskTotalSize];

    
    completeBlock(@{@"cpuUse":iS_Percent_Unit(system_cpu_usage.total),@"cpuFree":iS_Percent_Unit(100 - system_cpu_usage.total),@"ramAll":iS_GB_Unit(system_ram_usage.total_size),@"ramFree":iS_MB_Unit(system_ram_usage.available_size),@"wifiSent":iS_KB_Speed_Unit((networkFlow.total_sent - tempNetworkFlow.total_sent)),@"wifiReceive":iS_KB_Speed_Unit((networkFlow.total_received - tempNetworkFlow.total_received)),@"diskUsedSize":iS_GB_Unit(diskUsedSize),@"diskFreeSize":iS_GB_Unit(diskFreeSize),@"diskAllSize":iS_GB_Unit(diskAllSize)});
    
    tempNetworkFlow = networkFlow;

}

+ (NSString *)systemUpTime {
    
    return [self getDateStrFromTimeStep: [self systemUptime]];
    
}
+ (NSString *)systemRunningTime {
    
    return [self compareStarTime:[self getDateStrFromTimeStep:[self systemUptime]] endTime:[self getDateStrFromTimeStep: [self currentTime]]];
    
}
/// 上次开机时间
+ (NSTimeInterval)systemUptime {
    
    struct timeval t;
    size_t len=sizeof(struct timeval);
    if(sysctlbyname("kern.boottime",&t,&len,0,0)!=0) return 0.0;
    return t.tv_sec+t.tv_usec/USEC_PER_SEC;
    
}


/// 当前时间
+ (NSTimeInterval)currentTime {
    
    NSTimeInterval currentT = [[NSDate date] timeIntervalSince1970];
    return currentT;
    
}

/// 转换日期格式
/// @param timestep <#timestep description#>
+ (NSString *)getDateStrFromTimeStep:(NSTimeInterval)timestep {
    
    NSDate *timestepDate = [NSDate dateWithTimeIntervalSince1970:timestep];
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];

    [formatter setTimeZone:timeZone];

    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter stringFromDate:timestepDate];
    
}


/// 比较日期差值
/// @param time1 <#time1 description#>
/// @param time2 <#time2 description#>
+ (NSString *)compareStarTime:(NSString *)time1 endTime:(NSString *)time2 {
    
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    
    if (cmps.year != 0) {
        return [NSString stringWithFormat:@"%ld年%ld月%ld日%ld时%ld分%ld秒",cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second];
    } else if (cmps.month != 0) {
        return [NSString stringWithFormat:@"%ld月%ld日%ld时%ld分%ld秒", cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second];
    } else if (cmps.day != 0) {
           return [NSString stringWithFormat:@"%ld日%ld时%ld分%ld秒",cmps.day, cmps.hour, cmps.minute, cmps.second];
    } else {
        return [NSString stringWithFormat:@"%ld时%ld分%ld秒", cmps.hour, cmps.minute, cmps.second];
    }
    

}

@end
