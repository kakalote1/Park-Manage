//
//  AppDelegate.m
//  ImoocHybridIOSNative
//
//  Created by LGD_Sunday .
//  Copyright © LGD_Sunday. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TabFirst.h"
#import "TabSecond.h"
#import "TabThird.h"
#import "TabFourth.h"
#import <AFNetworking.h>
#import <ScPoc/SipSession.h>
#import <ScPoc/SipRegEvent.h>
#import <ScPoc/SipInviteEvent.h>
#import "AudioCallViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@property (strong, nonatomic) UINavigationController *navigationController;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化sc_sip核心类库
    NSLog(@"didFinishLaunchingWithOptions");
    self.sipContext = [SipContext sharedInstance];
    [self.sipContext startup];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInviteEventNotify:) name:NOTIFY_NAME_INVITE_EVENT
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRegistrationNotify:) name:NOTIFY_NAME_REGISTRATION_EVENT
                                               object:nil];
    
    // 创建根控制器
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [_window setRootViewController:[ViewController new]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: self.window.rootViewController];
    [self.window makeKeyAndVisible];

//    创建控制器
//    TabFirst* tabFirst = [[TabFirst alloc] init];
//    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:tabFirst];
//    nav1.navigationBar.barTintColor = [UIColor whiteColor];
//
//
//    TabSecond* tabSecond = [[TabSecond alloc] init];
//    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:tabSecond];
//    nav2.navigationBar.barTintColor = [UIColor whiteColor];
//
//    TabThird* tabThird = [[TabThird alloc] init];
//    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:tabThird];
//    nav3.navigationBar.barTintColor = [UIColor whiteColor];
//
//    TabFourth* tabFourth = [[TabFourth alloc] init];
//    UINavigationController * nav4 = [[UINavigationController alloc]initWithRootViewController:tabFourth];
//    nav4.navigationBar.barTintColor = [UIColor whiteColor];
//
//    WebViewController *routeController = [[WebViewController alloc] init];
//    UINavigationController * nav5 = [[UINavigationController alloc] initWithRootViewController:routeController];
//    nav5.navigationBar.barTintColor = [UIColor whiteColor];
//
//
//    tabFirst.title = @"工作台";
//    tabSecond.title = @"消息";
//    tabThird.title = @"通讯录";
//    tabFourth.title = @"个人中心";
//
//
//    tabFirst.navigationController.navigationBarHidden = YES;
//    tabSecond.navigationController.navigationBarHidden = YES;
//    tabThird.navigationController.navigationBarHidden = YES;
//    tabFourth.navigationController.navigationBarHidden = YES;
//    
//    tabFirst.view.backgroundColor = [UIColor whiteColor];
//    tabSecond.view.backgroundColor = [UIColor yellowColor];
//    tabThird.view.backgroundColor = [UIColor blueColor];
//    tabFourth.view.backgroundColor = [UIColor blueColor];
    
//    //创建分栏控制器
//    UITabBarController* tbController = [[UITabBarController alloc] init];
//
//    //创建一个控制器数组对象
//    //将所有的要被分栏控制器管理的对象添加到数组中
//    NSArray* arrayVC = [NSArray arrayWithObjects:nav1,
//                        nav2,
//                        nav3,
//                        nav4, nil];
//    //将分栏视图控制器管理数组赋值
//    tbController.viewControllers = arrayVC;
//
//    //将分栏控制器作为根视图控制器
//    self.window.rootViewController = tbController;
//
//    //设置分栏控制器的透明度
//    tbController.tabBar.translucent = NO;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // 在进程结束时，销毁sc库
    [self.sipContext shutdown];
    self.sipContext = nil;
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        [_sessionManager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [_sessionManager.requestSerializer setTimeoutInterval:10.0];
        [_sessionManager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
        [_sessionManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [_sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithArray:@[
                    @"application/json", @"text/plain", @"text/javascript",
                    @"text/json", @"text/html", @"image/jpeg",
                    @"image/png",@"video/mov", @"application/octet-stream"]]];
    }
    return _sessionManager;
}

- (void)serverRequestWithUrl {
    NSString *fullUrl = [NSString stringWithFormat:@"%@://%@", @"http", @"www.baidu.com"];
    NSDictionary *parameters = @{};
    
    [self postWithUrl:fullUrl withParams:parameters success:nil failure:nil];
}

- (void)postWithUrl:(NSString *)urlStr
         withParams:(NSDictionary *)params
            success:(nullable void (^)(NSDictionary * _Nonnull)) success
            failure:(nullable void (^)(NSError *)) failure {
    NSLog(@"url=%@\tparams=%@",urlStr, params);
    [self.sessionManager POST:urlStr
                   parameters:params
                      headers:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        if (responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            if (dic && success) {
                success(dic);
                return;
            }
        } else {
            error = [[NSError alloc] initWithDomain:NSNetServicesErrorDomain code:-1 userInfo:@{@"message":@"response is null"}];
        }
        if (failure) {
            failure(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - event handle

// 处理登入/登出sip服务器的通知
- (void)handleRegistrationNotify: (NSNotification *)notification {
    SipRegEvent *event = [notification object];
    NSLog(@"登录：code[%d] reason[%@]", event.code, event.reason);
}

// 处理呼叫事件通知
- (void)handleInviteEventNotify: (NSNotification *)notification {
    SipInviteEvent *event = [notification object];
    NSLog(@"Invite：id[%u] eventTYpe[%u] ringing[%@]", event.sessionId, event.eventType, (event.ringing ? @"YES" : @"NO"));
    
    SipSession *sipSession = [[SipContext sharedInstance] getCurrentSession];
    if (!sipSession || [sipSession getId] != [event sessionId]) {
        return;
    }
    // 根据呼叫事件类型做不同处理
    SipInviteEventType type = event.eventType;
    switch (type) {
            // 收到呼入
        case INCOMING:
            [self showCallView:sipSession];
            NSLog(@"收到呼入");
            break;
            // 呼出正在处理
        case INPROGRESS:
            [self showCallView:sipSession];
            NSLog(@"呼出正在处理");
            break;
            // 开始传输媒体流
        case EARLY_MEDIA:
            NSLog(@"开始传输媒体流");
            break;
            // 建立通话中
        case CONNECTING:
            NSLog(@"建立通话中");
            break;
            // 建立通话
        case CONNECTED:
            NSLog(@"建立通话");
            break;
            // 通话结束
        case TERMINATED:
            // 移除当前通话的session
            [[SipContext sharedInstance] removeCurrentSession];
            NSLog(@"通话结束");
            break;
    }
}

- (void)showCallView:(SipSession *)session {
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIViewController *vc;
        if ([session isVideoCall]) {
            
        } else {
            AudioCallViewController *audioVc = [[AudioCallViewController alloc] initWithNibName:@"AudioCallViewController" bundle:[NSBundle mainBundle]];
            [audioVc setAvSession:session];
            vc = audioVc;
        }
        [self.navigationController pushViewController:vc animated:YES];
    });
}

@end
