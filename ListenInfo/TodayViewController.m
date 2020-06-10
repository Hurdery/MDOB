//
//  TodayViewController.m
//  ListenInfo
//
//  Created by LY_MD on 2020/6/9.
//  Copyright © 2020 LY_MD. All rights reserved.
//

#import "TodayViewController.h"
#import "ListenManger.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController ()<NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UILabel *cpuUse;
@property (weak, nonatomic) IBOutlet UILabel *cpuFree;

@property (weak, nonatomic) IBOutlet UILabel *ramAll;
@property (weak, nonatomic) IBOutlet UILabel *ramFree;

@property (weak, nonatomic) IBOutlet UILabel *runingTime;

@property (weak, nonatomic) IBOutlet UILabel *romUse;
@property (weak, nonatomic) IBOutlet UIProgressView *romProgress;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
}
- (void)setUI {
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
          {
              self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
          }
       
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.view addGestureRecognizer:tapGestureRecognizer];
       

          [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
              [ListenManger startListen:^(NSDictionary * _Nonnull dic) {
                  [self configureData:dic];
              }];

          }];
    
    self.runingTime.textColor = [UIColor systemIndigoColor];

    
}

- (void)configureData:(NSDictionary *)dic {
    
    self.cpuUse.text = dic[@"cpuUse"];
    self.cpuFree.text = dic[@"cpuFree"];
    self.ramAll.text  = dic[@"ramAll"];
    self.ramFree.text = dic[@"ramFree"];
    self.runingTime.text = [ListenManger systemRunningTime];

    self.romUse.text = [NSString stringWithFormat:@"ROM实际可用：%@",dic[@"diskFreeSize"]];
    
    CGFloat usedSize = [dic[@"diskUsedSize"] floatValue];
    CGFloat allSize = [dic[@"diskAllSize"] floatValue];
    CGFloat progressValue = usedSize / allSize;
    self.romProgress.progress = progressValue;

}

- (void)handleSingleTap:(UITapGestureRecognizer *)ges {
    
          NSString *urlString = [NSString stringWithFormat:@"WidgetMain://"];
          NSURL *url = [NSURL URLWithString:urlString];
          [self.extensionContext openURL:url completionHandler:nil];
      
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    NSLog(@"maxWidth %f maxHeight %f",maxSize.width,maxSize.height);
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact)
    {
        self.preferredContentSize = CGSizeMake(maxSize.width, 110);
    }
    else
    {
        self.preferredContentSize = CGSizeMake(maxSize.width, 270);
    }
}

@end
