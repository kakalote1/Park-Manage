//
//  AppDelegate.m
//  ImoocHybridIOSNative
//
//  Created by LGD_Sunday .
//  Copyright © LGD_Sunday. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TabFourth.h"
#import <AFNetworking.h>
#import <ScPoc/SipSession.h>
#import <ScPoc/SipRegEvent.h>
#import <ScPoc/SipInviteEvent.h>
#import "AudioCallViewController.h"
#import "VideoCallViewController.h"
#import "XGPush.h"
#import "XGPushPrivate.h"
#import <UserNotifications/UserNotifications.h>
#import "LoginViewController.h"
#import <ScPoc/IphoneControl.h>
#import "HttpManager.h"
#import "UserModel.h"
#import <WebKit/WebKit.h>
#import <Bugly/Bugly.h>
#import "FaceLoginViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AudioMeetingViewController.h"
#import "VideoMeetingViewController.h"

@interface AppDelegate () <XGPushDelegate, CLLocationManagerDelegate>

{
CLLocationManager *locationmanager;//定位服务

NSString *strlatitude;//经度

NSString *strlongitude;//纬度
}

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UserModel *userInfo;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bugly startWithAppId:@"3bdfb2eb2c"];
    // 初始化sc_sip核心类库
    NSLog(@"didFinishLaunchingWithOptions");
    self.sipContext = [SipContext sharedInstance];
    [self.sipContext startup];
    
    [self startLocation];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"userinfo.plist"];
    
    [filemanager createFileAtPath:plistPath contents:nil attributes:nil];
    
    [[HttpManager shareInstance]postRequestWithUrl:@"https://service.yzyby2018.com/jiekou/common-api/common/login/getAccessToken" andParam:@{
        @"source": @"APP"} andHeaders:nil andSuccess:^(id responseObject) {
        NSLog(@"获取成功：%@", responseObject);
        NSString *str = responseObject[@"data"];
        NSLog(@"accessToken: %@",str);
        NSDictionary *dic = @{@"accessToken":str};
        [dic writeToFile:plistPath atomically:YES];
        NSLog(@"%@",dic);
        NSDictionary *dic2 = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSLog(@"asdasdas");
        NSLog(@"%@\n%@",[dic2 objectForKey:@"accessToken"],filePath);
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:str forKey:@"accessToken"];
    } andFail:^(id error) {
                
            }];
    
    NSDictionary *dic2 = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"asdasdas");
    NSLog(@"%@\n%@",[dic2 objectForKey:@"accessToken"],filePath);
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.userInfo = [UserModel shareInstance];
    
    [self.userInfo addObserver:self forKeyPath:@"uid" options:NSKeyValueObservingOptionNew context:nil];

	[[XGPush defaultManager] configureClusterDomainName:@"tpns.sh.tencent.com"];
	[[XGPush defaultManager] startXGWithAccessID:1680003686 accessKey:@"IR5D9D6I6KFW" delegate:self];
//    打开 debug 开关
    [[XGPush defaultManager] setEnableDebug:YES];
    
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
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userInfo objectForKey:@"uid"];


    LoginViewController *loginVc = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    self.window.rootViewController = nav;

    loginVc.navigationController.navigationBarHidden = YES;
    self.navigationController = (UINavigationController *) self.window.rootViewController;
    
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

/// 统一接收消息的回调
/// @param notification 消息对象(有2种类型NSDictionary和UNNotification具体解析参考示例代码)
/// @note 此回调为前台收到通知消息及所有状态下收到静默消息的回调（消息点击需使用统一点击回调）
/// 区分消息类型说明：xg字段里的msgtype为1则代表通知消息msgtype为2则代表静默消息
- (void)xgPushDidReceiveRemoteNotification:(nonnull id)notification withCompletionHandler:(nullable void (^)(NSUInteger))completionHandler{
/// code
    NSLog(@"信鸽推送: %@", notification);
}
/// 统一点击回调
/// @param response 如果iOS 10+/macOS 10.14+则为UNNotificationResponse，低于目标版本则为NSDictionary
- (void)xgPushDidReceiveNotificationResponse:(nonnull id)response withCompletionHandler:(nonnull void (^)(void))completionHandler {
/// code
}

- (void)xgPushDidRegisteredDeviceToken:(NSString *)deviceToken xgToken:(NSString *)xgToken error:(NSError *)error{
    NSLog(@"deviceToken : %@", deviceToken);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:deviceToken forKey:@"deviceToken"];
    
    NSString *uid = [user objectForKey:@"uid"];
    
    if (uid.length > 6) {
        NSDictionary *param = @{@"uid": uid, @"loginUid": uid, @"devToken": deviceToken, @"devType": @"1"};
        NSString *url = @"http://58.220.201.130:12383/zlw/data/thirdPart/saveDevInfo";
        [[HttpManager shareInstance] getRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
                NSLog(@"关联设备成功: %@", responseObject);
            } andFail:^(id error) {
                
            }];
    }
}

/// 注册推送服务失败回调
/// @param error 注册失败错误信息
/// @note TPNS SDK1.2.7.1+
- (void)xgPushDidFailToRegisterDeviceTokenWithError:(nullable NSError *)error {
    NSLog(@"信鸽注册失败: %@", error);
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 1. 创建 dispatch source，指定检测事件为定时
    UserModel *user = [UserModel shareInstance];
    if (user.uid != nil && user.uid.length != 0) {
        [self startLoop];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   
//    UserModel *user = [UserModel shareInstance];
//    if (user.uid != nil && user.uid.length != 0) {
//        [self startLoop];
//    }

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
    NSString *fullUrl = [NSString stringWithFormat:@"https://service.yzyby2018.com/jiekou/common-api/common/login/getAccessTokenm"];
    NSDictionary *parameters = @{@"source": @"APP"};
    
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
            NSLog(@"数据：%@", responseObject);
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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"uid"] && object == self.userInfo)
    {
        [self startLoop];
    }
}
// 登录监听
- (void)handleLoginNotify: (NSNotification *)notifacation {
    
}
// 处理登入/登出sip服务器的通知
- (void)handleRegistrationNotify: (NSNotification *)notification {
    SipRegEvent *event = [notification object];
    NSLog(@"登录：code[%d] reason[%@]", event.code, event.reason);
}

// 处理呼叫事件通知
- (void)handleInviteEventNotify: (NSNotification *)notification {
    SipInviteEvent *event = [notification object];
    NSLog(@"Invite：id[%u] eventTYpe[%ld] ringing[%@]", event.sessionId, (long)event.eventType, (event.ringing ? @"YES" : @"NO"));
    
    SipSession *sipSession = [[SipContext sharedInstance] getCurrentSession];
    if (!sipSession || [sipSession getId] != [event sessionId]) {
        return;
    }
    // 根据呼叫事件类型做不同处理
    SipInviteEventType type = event.eventType;
    switch (type) {
            // 收到呼入
        case INCOMING:
            if ([sipSession isMeeting]) {
                [self showMeetingView:sipSession];
            } else {
                [self showCallView:sipSession];
            }
            break;
            // 呼出正在处理
        case INPROGRESS:
            [[IphoneControl shareInstance] startRing];
            [[IphoneControl shareInstance] startVibrator];
            if ([sipSession isMeeting]) {
                [self showMeetingView:sipSession];
            } else {
                [self showCallView:sipSession];
            }
            break;
            // 开始传输媒体流
        case EARLY_MEDIA:
            NSLog(@"开始传输媒体流");
            break;
            // 建立通话中
        case CONNECTING:
            [[IphoneControl shareInstance] stopRing];
            [[IphoneControl shareInstance] stopVibrator];
            NSLog(@"建立通话中");
            break;
            // 建立通话
        case CONNECTED:
            NSLog(@"建立通话");
            break;
            // 通话结束
        case TERMINATED:
            // 移除当前通话的session
            [[IphoneControl shareInstance] stopRing];
            [[IphoneControl shareInstance] stopVibrator];
            [[SipContext sharedInstance] removeCurrentSession];
            NSLog(@"通话结束");
            break;
    }
}

// 弹出通话页面
- (void)showCallView:(SipSession *)session {
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIViewController *vc;
        // 判断是否为视频通话
        if ([session isVideoCall]) {
            VideoCallViewController *videoVc = [[VideoCallViewController alloc] init];
            [videoVc setAvSession:session];
            vc = videoVc;
        } else {
            AudioCallViewController *audioVc = [[AudioCallViewController alloc] init];
            [audioVc setAvSession:session];
            vc = audioVc;
        }
//        loginVc.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self.navigationController pushViewController:vc animated:YES];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
//        ViewController *vc2 = [[ViewController alloc] init];
//        [vc2 presentViewController:vc animated:YES completion:nil];
    });
}

- (void)showMeetingView:(SipSession *)session {
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIViewController *vc;
        if ([session isVideoCall]) {
            VideoMeetingViewController *videoVc = [[VideoMeetingViewController alloc] init];
            vc = videoVc;

        } else {
            AudioMeetingViewController *audioVc = [[AudioMeetingViewController alloc] init];
            vc = audioVc;
        }
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    });
}

#pragma mark - 定位
//开始定位
-(void) startLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 5.0;
        [locationmanager startUpdatingLocation];
    }
}

#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"经纬度%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    NSString *latitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    
    [self.userInfo setLatitude:latitude];
    [self.userInfo setLongitude:longitude];
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
    {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"placemark : %@", placemark.postalAddress);
            
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            // 位置名
            NSLog(@"name,%@",placemark.name);
            // 街道
            NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            // 子街道
            NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            // 市
            NSLog(@"locality,%@",placemark.locality);
            // 区
            NSLog(@"subLocality,%@",placemark.subLocality);
            // 国家
            NSLog(@"country,%@",placemark.country);
            NSString *address = [placemark.country stringByAppendingFormat:@"%@%@%@%@%@",placemark.administrativeArea, city,placemark.subLocality,placemark.thoroughfare,placemark.name];
            NSLog(@"address ： %@", address);
            [self.userInfo setAddress:address];
              }else if (error == nil && [placemarks count] == 0) {
                  NSLog(@"No results were returned.");
              } else if (error != nil){
                  NSLog(@"An error occurred = %@", error);
              }
    }];
}

- (void)startLoop
{
        [NSThread detachNewThreadSelector:@selector(loopMethod) toTarget:self withObject:nil];
}

- (void)loopMethod
{
    [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(keepAlive) userInfo:nil repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}

- (void)keepAlive {
    NSString *url = @"http://58.220.201.130:12383/zlw/data/thirdPartLogin/keepAlive";
    NSString *uid = [UserModel shareInstance].uid;
    NSDictionary *param = @{@"uid": uid, @"isFirst": @"0"};
    [[HttpManager shareInstance] getRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
            NSLog(@"账号正在活动: %@", responseObject);
        } andFail:^(id error) {
            NSLog(@"保活失败: %@", error);
        }];
}

-(UserModel *)userInfo {
    if (!_userInfo) {
        _userInfo = [UserModel shareInstance];
    }
    return _userInfo;
}

@end


