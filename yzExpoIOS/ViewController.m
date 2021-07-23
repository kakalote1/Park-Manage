//
//  ViewController.m
//  ImoocHybridIOSNative
//
//  Created by LGD_Sunday .
//  Copyright © LGD_Sunday. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "Constants.h"
#import <ScPoc/SipContext.h>
#import <ScPoc/SipSession.h>
#import <ScPoc/SipRegEvent.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "CallUtil.h"
#import <AFNetworking/AFNetworking.h>
#import "UserModel.h"
#import "LoginViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WebViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ScPoc/SipSettings.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler,CLLocationManagerDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *wkWebViewConfiguration;
@property (nonatomic, strong) WKUserContentController *wkUserContentController;
@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) UserModel *userInfo;
@property (nonatomic, strong) AVPlayerViewController *avPlayerVc;
@property (nonatomic, strong) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


@end

//是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define kIs_iPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0f ||[UIScreen mainScreen].bounds.size.height == 896.0f ||[UIScreen mainScreen].bounds.size.height == 844.0f ||[UIScreen mainScreen].bounds.size.height == 926.0f)
#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)

@implementation ViewController


- (UIImageView *)iv {
    if (!_iv) {
        _iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome.png"]];
        _iv.frame = self.view.bounds;
    }
    return _iv;
}

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateLocation:) name:@"updateLocaltion" object:nil];
    if (kIs_iPhoneX) {
        self.view.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 34);
    }
    
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        NSString *ip = @"58.220.201.130";
        NSString *port = @"9999";
        uint16_t portNum = [port intValue];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 13.0) {
        [[self getSipContext] loginWithUid:uid host:ip port:portNum tls:true];
        [[self getSipContext].settings setVideoTransUseUdp: FALSE];
        [[self getSipContext].settings setQosPrefVideoSize:2];
        [[self getSipContext].settings setVideoEncoderBitrate:1500];
        [[self getSipContext].settings setVideoEncoderFps:15];
    }
  

    NSString *devToken = [UserModel shareInstance].devToken;
    
    if (devToken.length > 0 && uid.length > 0) {
        NSDictionary *param = @{@"uid": uid, @"loginUid": uid, @"devToken": devToken, @"devType": @"1"};
        NSString *url = @"http://58.220.201.130:12383/zlw/data/thirdPart/saveDevInfo";
        [[HttpManager shareInstance] getRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
                NSLog(@"关联设备成功: %@", responseObject);
            } andFail:^(id error) {
                
            }];
    }
    [self initWebView];
    [self.activityIndicator startAnimating];

}

- (void)initWebView {

    //配置wkWebViewConfiguration
    [self wkConfiguration];
    //初始化webView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:self.wkWebViewConfiguration];
    self.webView.backgroundColor = [UIColor whiteColor];
    
    //关闭左划回退功能
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.scrollView.bounces = FALSE;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.allowsLinkPreview = FALSE;

    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    //    设置 URL 访问，如要修改访问地址，需要修改 常量/Constants.h/BASE_WEB_URL
    NSURL *url = [NSURL URLWithString:BASE_WEB_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:500];
    [self.webView loadRequest:request];
//    [self localLoad];
    
    //解决 iOS 11 屏幕顶部显示不全
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.iv];
    
    
    //OC注册供JS调用的方法
    [self addScriptFunction];
}

//- (void)localLoad {
//    NSString *path = [[NSBundle mainBundle] resourcePath];
//    NSString *basePath = [NSString stringWithFormat:@"%@/%@",path, @"Resource.bundle/dist"];
//    NSString *htmlPath = [NSString stringWithFormat:@"%@/%@",path, @"Resource.bundle/dist/index.html"];
//    NSURL *fileUrl = [NSURL fileURLWithPath:htmlPath];
//    NSLog(@"path: %@, basePath: %@, htmlPath: %@, fileUrl: %@", path, basePath, htmlPath, fileUrl);
//    [self.webView loadFileURL:fileUrl allowingReadAccessToURL:[NSURL fileURLWithPath:basePath isDirectory:YES]];
//
//}

- (void)wkConfiguration {
    self.wkWebViewConfiguration = [[WKWebViewConfiguration alloc]init];
    self.wkWebViewConfiguration.userContentController = [WKUserContentController new];
    
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    self.wkWebViewConfiguration.preferences = preferences;
}

#pragma mark -  OC注册供JS调用的方法
- (void)addScriptFunction {
    self.wkUserContentController = [self.webView configuration].userContentController;
    
    [self.wkUserContentController addScriptMessageHandler:self name:@"register"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"login"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"logout"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"makeAudioCall"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"makeVideoCall"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"makeAudioGroupCall"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"makeVideoGroupCall"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"uidLogin"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"Login"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"goBack"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"goHome"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"avplayer"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"reload"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"jumpToStore"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"shareWorkOrder"];
    
//    NSString *uid = [UserModel shareInstance].uid;
//    NSString *js = [NSString stringWithFormat:@"window.IOSInfo = %@", uid];
//
//    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:(WKUserScriptInjectionTimeAtDocumentStart) forMainFrameOnly:YES];
//    [self.wkWebViewConfiguration.userContentController addUserScript:script];
}

//#pragma mark -  Alert弹窗
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }];
//    [alertController addAction:action];
//    [self presentViewController:alertController animated:YES completion:nil];
//}


#pragma mark - WKWebView
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    关闭欢迎图片
    self.iv.hidden = YES;
    [self.activityIndicator stopAnimating];

    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSLog(@"js uid : %@", uid);
    // 将分享结果返回给js
//      NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
//        NSMutableDictionary *dic = [NSMutableDictionary new];
//        dic[@"uid"] = [UserModel shareInstance].uid;
//        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:(NSJSONWritingPrettyPrinted) error:nil];
//
//        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    [self.webView evaluateJavaScript:[NSString stringWithFormat: @"localStorage.setItem('iosUid', '%@' );", uid] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//              NSLog(@"%@----%@",result, error);
//          }];
//
//    [self.webView evaluateJavaScript:[NSString stringWithFormat: @"login('%@')", uid] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"%@----%@",result, error);
//    }];
    
    NSString *url = @"http://58.220.201.130:12383/scooper-app-msg/gis/updateGis";
    NSString *longitude = [UserModel shareInstance].longitude;
    NSString *latitude = [UserModel shareInstance].latitude;
    NSString *address = [UserModel shareInstance].address;
    NSLog(@"获取位置参数: %@ %@ %@ %@",uid, longitude, latitude, address);
    NSLog(@"位置参数长度: %lu %lu %lu", (unsigned long)longitude.length, (unsigned long)latitude.length, (unsigned long)address.length);
    if (longitude.length > 0 && latitude.length > 0 && address.length > 0) {
        NSDictionary *location = @{@"longitude": longitude, @"latitude": latitude, @"address": address};
        NSData *data = [NSJSONSerialization dataWithJSONObject:location options:kNilOptions error:nil];
        NSString *locationStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"locationStr: %@",locationStr);
        [self.webView evaluateJavaScript:[NSString stringWithFormat: @"localStorage.setItem('location', '%@' );", locationStr] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
        
        NSDictionary *param  = @{@"uid":uid,@"longitude":longitude,@"latitude":latitude};
        
        [[HttpManager shareInstance] getRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
                NSLog(@"上报位置成功: %@", responseObject);
            } andFail:^(id error) {
                
            }];
    }
    [self isAutoLogin];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //如果是跳转一个新页面
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
            NSLog(@"55555");
        }
    
    NSString *url = navigationAction.request.URL.absoluteString;
    NSLog(@"route url : %@", url);
    NSArray *array = [url componentsSeparatedByString:@"#"];
    NSLog(@"url array : %@", array);
    if ([array containsObject:@"/operationalTesting/videoSurveillance"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:500];
        [self.webView loadRequest:request];
    }
    if (url.length > 30) {
        url = [url substringToIndex:21];
    }
    NSLog(@"newurl : %@", url);

    if ([url isEqual:@"http://58.220.201.130"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
//        self.hidesBottomBarWhenPushed=YES;
        WebViewController *webVc = [[WebViewController alloc] init];
        [webVc initWebView:navigationAction.request.URL.absoluteString withTitle:@"事件列表"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationController pushViewController:webVc animated:YES];
//            self.hidesBottomBarWhenPushed=NO;
    }
    else if ([url isEqual:@"http://221.181.152.11"]) {
       decisionHandler(WKNavigationActionPolicyCancel);

        WebViewController *webVc = [[WebViewController alloc] init];
        [webVc initWebView:navigationAction.request.URL.absoluteString withTitle:@"视频播放"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationController pushViewController:webVc animated:YES];
        webVc.navigationController.navigationBarHidden=NO;

   }
    else{
        decisionHandler(WKNavigationActionPolicyAllow);

    }
    
    
    NSLog(@"5432122: %@", url);
}

#pragma mark 判断用户自动登录
- (void)isAutoLogin {
    NSString *username = [self.userDefaults objectForKey:AUTO_LOGIN];
    
    if (username == nil || [username isEqualToString:@""]) {
        return;
    }
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"nativeFunctionUserLogin('%@')", username] completionHandler:nil];
}

#pragma mark --- WKScriptMessageHandler ---
//OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    CallUtil *call = [[CallUtil alloc] init];
    // 根据name做想做的操作
    //前端主动JS发送消息，前端指令动作
    if ([@"register" isEqualToString:message.name]) {
        [self register:message.body];
    } else if ([@"login" isEqualToString:message.name]) {
        [self login:message.body];
    } else if ([@"logout" isEqualToString:message.name]) {
        [self logout:message.body];
    } else if ([@"makeAudioCall" isEqualToString:message.name]) {
        NSLog(@"body:%@",message.body);
        [call makeAudioCall:message.body];
    } else if ([@"makeVideoCall" isEqualToString:message.name]) {
        NSLog(@"body:%@",message.body);
        [call makeVideoCall:message.body];
    } else if ([@"makeAudioGroupCall" isEqualToString:message.name]) {
        NSLog(@"body:%@",message.body);
        [call makeAudioGroupCall:message.body];
    } else if ([@"makeVideoGroupCall" isEqualToString:message.name]) {
        NSLog(@"body:%@",message.body);
        [call makeVideoGroupCall:message.body];
    } else if ([@"uidLogin" isEqualToString:message.name]) {
        NSLog(@"body:%@",message.body);
//        [self uidLogin:message.body];
    } else if ([@"Login" isEqualToString:message.name]) {
        [self Login];
    } else if ([@"goBack" isEqualToString:message.name]) {
        [self goBack];
    } else if ([@"goHome" isEqualToString:message.name]) {
        [self goHome];
    } else if ([@"avplayer" isEqualToString:message.name]) {
        [self avplayer:message.body];
    } else if ([@"reload" isEqualToString:message.name]) {
        [self reload];
    } else if ([@"jumpToStore" isEqualToString:message.name]) {
        [self jumpToStore];
    } else if ([@"shareWorkOrder" isEqualToString:message.name]) {
        [self shareWorkOrder];
    }
}

- (void)goHome {
    if (self.webView.canGoBack == YES) {
        [self.webView goBack];
    } else {
        [self.webView reload];
    }
}

- (void)goBack {
    if (self.webView.canGoBack == YES) {
        [self.webView goBack];
    } else {
        [self.webView reload];
    }
}

- (void)reload {
    [self.webView reload];
}

#pragma mark - 注册
- (void)register:(id)body {
     NSDictionary *dict = body;
    [self.userDefaults setObject:[dict objectForKey:@"password"] forKey:[dict objectForKey:@"username"]];
    [self.webView evaluateJavaScript:@"registerCallback(true)" completionHandler:nil];
}

#pragma mark - 登录
- (void)login:(id)body {
    NSDictionary *dict = body;
    
    // 根据用户名来获取在原生端保存的密码
    NSString *password = [self.userDefaults objectForKey:[dict objectForKey:@"username"]];
    // 如果获取到的密码为null，表示当前的用户未注册
    if (password == nil || [password isEqualToString:@""]) {
        [self.webView evaluateJavaScript:@"loginCallback('1')" completionHandler:nil];
        return;
    }
    
    // 如果原生保存的密码和用户输入的密码不相同，表示用户密码输入错误
    if (![password isEqualToString:[dict objectForKey:@"password"]]) {
        [self.webView evaluateJavaScript:@"loginCallback('2')" completionHandler:nil];
        return;
    }
    
    // 通过前面的判断表示，用户登录成功，保存当前登录的用户名称，并通知前端
    [self.userDefaults setObject:[dict objectForKey:@"username"] forKey: AUTO_LOGIN];
   [self.webView evaluateJavaScript:@"loginCallback('0')" completionHandler:nil];
}

- (void)avplayer: (NSString *) sender
{
    NSURL *url = [NSURL URLWithString:sender];
   self.avPlayerVc = [[AVPlayerViewController alloc] init];
    self.avPlayerItem = [[AVPlayerItem alloc] initWithURL:url];
    self.avPlayerVc.showsPlaybackControls = YES;
    self.avPlayerVc.player = [[AVPlayer alloc] initWithPlayerItem:self.avPlayerItem];
    if (self.avPlayerVc.readyForDisplay) {
        [self.avPlayerVc.player play];
    }
    [self presentViewController:self.avPlayerVc animated:YES completion:nil];
    

}

#pragma mark - 退出登录
- (void)logout:(id)body {
//    [self.userDefaults removeObjectForKey:AUTO_LOGIN];
    [self.navigationController popViewControllerAnimated:YES];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    [[self getSipContext] logoutSip];
    [user removeObjectForKey:@"uid"];
    
    [self.webView evaluateJavaScript:@"window.localStorage.clear()" completionHandler:nil];
}

- (void)Login {
    NSLog(@"登录12345");
    NSString *uid = [self.userDefaults objectForKey:@"uid"];
    NSLog(@"js uid : %@", uid);
    // 将分享结果返回给js
    [self.webView evaluateJavaScript:[NSString stringWithFormat: @"localStorage.setItem('iosUid', '%@' );", uid] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    NSLog(@"%@----%@",result, error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRegEvent:) name:NOTIFY_NAME_REGISTRATION_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation) name:@"updateLocation" object:nil];
}

// 实时更新位置信息
-(void)updateLocation {
    NSLog(@"更新位置信息");
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *url = @"http://58.220.201.130:12383/scooper-app-msg/gis/updateGis";
    NSString *longitude = [UserModel shareInstance].longitude;
    NSString *latitude = [UserModel shareInstance].latitude;
    NSString *address = [UserModel shareInstance].address;
    NSLog(@"获取位置参数: %@ %@ %@ %@",uid, longitude, latitude, address);
    NSLog(@"位置参数长度: %lu %lu %lu", (unsigned long)longitude.length, (unsigned long)latitude.length, (unsigned long)address.length);
    if (longitude.length > 0 && latitude.length > 0 && address.length > 0) {
        NSDictionary *location = @{@"longitude": longitude, @"latitude": latitude, @"address": address};
        NSData *data = [NSJSONSerialization dataWithJSONObject:location options:kNilOptions error:nil];
        NSString *locationStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"locationStr: %@",locationStr);
        [self.webView evaluateJavaScript:[NSString stringWithFormat: @"localStorage.setItem('location', '%@' );", locationStr] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
        
        NSDictionary *param  = @{@"uid":uid,@"longitude":longitude,@"latitude":latitude};
        
        [[HttpManager shareInstance] getRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
                NSLog(@"更新上报位置成功: %@", responseObject);
            } andFail:^(id error) {
                
            }];
    }
}

// 跳转商城
- (void)jumpToStore {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://apps.apple.com/us/app/2021nian-yang-zhou-shi-yuan-hui-zong-he-guan-liapp/id1551534885"]];
    [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];


    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_NAME_REGISTRATION_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLocation" object:nil];
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [manager setDesiredAccuracy: kCLLocationAccuracyBest];
    
    [manager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];

    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSString *latitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];

    NSLog(@"经纬度%@,%@",latitude,longitude);

    
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
        NSString *longitude = [UserModel shareInstance].longitude;
        NSString *latitude = [UserModel shareInstance].latitude;
        NSString *address = [UserModel shareInstance].address;
        NSLog(@"位置参数长度: %lu %lu %lu", (unsigned long)longitude.length, (unsigned long)latitude.length, (unsigned long)address.length);
        if (longitude.length > 0 && latitude.length > 0 && address.length > 0) {
            NSDictionary *location = @{@"longitude": longitude, @"latitude": latitude, @"address": address};
            NSData *data = [NSJSONSerialization dataWithJSONObject:location options:kNilOptions error:nil];
            NSString *locationStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"locationStr: %@",locationStr);
            [self.webView evaluateJavaScript:[NSString stringWithFormat: @"localStorage.setItem('location', '%@' );", locationStr] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"%@----%@更新地址",result, error);
            }];
        }
    }];
}

- (void)notificationRegEvent:(NSNotification *)notification {
    SipRegEvent *event = [notification object];
    if (event.code / 100 != 2) {
        NSLog(@"登录失败：code[%d] reason[%@]", event.code, event.reason);
        return;
    }
    NSLog(@"登录成功");
}

- (void)shareWorkOrder {
    UIGraphicsBeginImageContext(self.view.bounds.size); //currentView当前的view

    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);

    UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
//    [self.view makeToast:@"保存成功!"];

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self.view makeToast:@"保存成功!"];
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

// 检查权限
- (BOOL)checkPermission {
    if (![self checkMicrophone]) {
        return  NO;
    }
    if (![self checkCamera]) {
        return  NO;
    }
    return YES;
}

// 检查麦克风权限
- (BOOL)checkMicrophone {
    AVAuthorizationStatus microphoneStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (microphoneStatus) {
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            [self goMicrophoneSet];
            return NO;
        case AVAuthorizationStatusNotDetermined:
            [self requestMicrophoneAuth];
            return NO;
        case AVAuthorizationStatusAuthorized:
            break;
        default:
            return NO;;
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    AVAudioSessionRecordPermission permission = session.recordPermission;
    switch (permission) {
        case AVAudioSessionRecordPermissionDenied:
            [self goMicrophoneSet];
            return NO;
        case AVAudioSessionRecordPermissionUndetermined:
            [self requestRecordPermission];
            return NO;
        case AVAudioSessionRecordPermissionGranted:
            break;
        default:
            return NO;
    }
    return YES;
}

// 跳转麦克风设置
- (void)goMicrophoneSet {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您还没有允许麦克风权限" message:@"去设置一下吧" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [UIApplication.sharedApplication openURL:url options:nil completionHandler:^(BOOL success) {
                
            }];
        });
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:setAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) requestMicrophoneAuth {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {}];
}

- (void)requestRecordPermission {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session requestRecordPermission:^(BOOL granted) {}];
}

// 检查相机权限
- (BOOL)checkCamera {
    AVAuthorizationStatus microphoneStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (microphoneStatus) {
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            [self goCameraSet];
            return NO;
        case AVAuthorizationStatusNotDetermined:
            [self requestCameraAuth];
            return NO;
        case AVAuthorizationStatusAuthorized:
            return YES;
        default:
            return NO;

    }
}

// 跳转相机设置
-(void) goCameraSet {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"您还没有允许录像权限" message:@"去设置一下吧" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [UIApplication.sharedApplication openURL:url options:nil completionHandler:^(BOOL success) {

            }];
        });
    }];

    [alert addAction:cancelAction];
    [alert addAction:setAction];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void) requestCameraAuth {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {}];
}

- (UserModel *) userInfo {
    if (_userInfo) {
        _userInfo = [UserModel shareInstance];
    }
    return _userInfo;
}

#pragma mark - 小菊花
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        _activityIndicator.frame = CGRectMake(0, 0, 100.0f, 100.0f);
          //设置小菊花的frame
        _activityIndicator.center = self.view.center;
          //设置小菊花颜色
//          _activityIndicator.color = [UIColor redColor];
          //设置背景颜色
        _activityIndicator.backgroundColor = [UIColor colorWithWhite:0.33 alpha:0.9];        _activityIndicator.layer.cornerRadius = 10.0f;
        _activityIndicator.hidesWhenStopped = YES;
          //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
//          _activityIndicator.hidesWhenStopped = NO;
        [self.view addSubview:_activityIndicator];
    }

    return _activityIndicator;
  
}
@end
