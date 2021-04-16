//
//  BaseViewController.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/2/1.
//  Copyright © 2021 LGD_Sunday. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@property (weak, nonatomic) SipContext *sipContext;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        //主线程执行
        self.sipContext = ((AppDelegate *) [UIApplication sharedApplication].delegate).sipContext;
}

- (void)dealloc {
    _sipContext = nil;
}

- (SipContext *)getSipContext {
    return ((AppDelegate *) [UIApplication sharedApplication].delegate).sipContext;
;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
