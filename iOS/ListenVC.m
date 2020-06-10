//
//  ListenVC.m
//  iOS
//
//  Created by LY_MD on 2020/6/9.
//  Copyright © 2020 LY_MD. All rights reserved.
//

#import "ListenVC.h"
#import "ListenManger.h"

@interface ListenVC ()

@property (weak, nonatomic) IBOutlet UILabel *wifiSent;
@property (weak, nonatomic) IBOutlet UILabel *wifiReceive;

@property (weak, nonatomic) IBOutlet UILabel *cpuUse;
@property (weak, nonatomic) IBOutlet UILabel *cpuFree;

@property (weak, nonatomic) IBOutlet UILabel *ramAll;
@property (weak, nonatomic) IBOutlet UILabel *ramFree;

@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *runTime;


@end

@implementation ListenVC
- (void)viewDidLoad {
    [super viewDidLoad];

    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [ListenManger startListen:^(NSDictionary * _Nonnull dic) {
            [self configureData:dic];
        }];

    }];
     
}

- (void)configureData:(NSDictionary *)dic {
    
    self.wifiSent.text = dic[@"wifiSent"];
    self.wifiReceive.text = dic[@"wifiReceive"];
    self.cpuUse.text = dic[@"cpuUse"];
    self.cpuFree.text = dic[@"cpuFree"];
    self.ramAll.text  = dic[@"ramAll"];
    self.ramFree.text = dic[@"ramFree"];
        
    self.startTime.text = [ListenManger systemUpTime];
    self.runTime.text =  [ListenManger systemRunningTime];

}


@end
