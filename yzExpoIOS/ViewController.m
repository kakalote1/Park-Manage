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

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *wkWebViewConfiguration;
@property (nonatomic, strong) WKUserContentController *wkUserContentController;
@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

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
    
    [self initWebView];
    
    [self Login];
    
    [((AppDelegate *) [UIApplication sharedApplication].delegate) serverRequestWithUrl];

}

- (void)initWebView {

    //配置wkWebViewConfiguration
    [self wkConfiguration];
    //初始化webView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:self.wkWebViewConfiguration];
    self.webView.backgroundColor = [UIColor whiteColor];
    
    //关闭左划回退功能
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    //    设置 URL 访问，如要修改访问地址，需要修改 常量/Constants.h/BASE_WEB_URL
    NSURL *url = [NSURL URLWithString:BASE_WEB_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:500];
    [self.webView loadRequest:request];
    
    //解决 iOS 11 屏幕顶部显示不全
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
        
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.iv];
    
    //OC注册供JS调用的方法
    [self addScriptFunction];
}

- (void)wkConfiguration {
    self.wkWebViewConfiguration = [[WKWebViewConfiguration alloc]init];
    
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
}

#pragma mark -  Alert弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}


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
        NSLog(@"5432122");
        decisionHandler(WKNavigationActionPolicyAllow);
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
        [self uidLogin:message.body];
    }
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

#pragma mark - 退出登录
- (void)logout:(id)body {
    [self.userDefaults removeObjectForKey:AUTO_LOGIN];
    [self.webView evaluateJavaScript:@"logoutCallback(true)" completionHandler:nil];
}

// 模拟sip登录
- (void)Login {
    NSLog(@"登录12345");
//    if (![self checkPermission]) {
//        return;
//    }
//    [[self getSipContext] loginToSip:@"3001" pass:@"abc123" host:@"122.224.180.122" port:12379 tls:TRUE];
//    NSLog(@"hhhhhhh");
}

// sip登录
- (void)uidLogin:(NSString *)uid {
    NSLog(@"uid: %@",uid);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *ip = @"122.224.180.122";
        NSString *port = @"12381";
        NSString *urlStr = [[NSString alloc] initWithFormat:@"http://%@:%@/zlw/data/thirdPartLogin/getSipUserInfoByUid?uid=%@",ip,port,uid];
        NSLog(@"url: %@", urlStr);
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlStr parameters:nil error:nil];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, NSData *responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
//                NSLog(@"请求数据%@  \n\n\n data%@", response, responseObject);
                NSLog(@"12222%@",responseObject);
                NSData *jsonStr = (NSData *)responseObject;
                NSLog(@"jsonStr: %@",jsonStr);
                NSDictionary *dict = (NSDictionary *) jsonStr;
                NSDictionary *data = [dict objectForKey:@"data"];
                NSLog(@"dict: %@", data);
                NSString *sipTel = [data objectForKey:@"sipTel"];
                NSString *ip = [data objectForKey:@"natIp"];
                NSString *pwd = [data objectForKey:@"sipPwd"];
                NSString *portStr = [data objectForKey:@"tlsPort"];
                int port = [portStr intValue];
                [[self getSipContext] loginToSip:sipTel pass:pwd host:ip port:port tls:TRUE];
            }
        }];
        [dataTask resume];

    });
    if (![self checkPermission]) {
        return;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRegEvent:) name:NOTIFY_NAME_REGISTRATION_EVENT object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_NAME_REGISTRATION_EVENT object:nil];
}

- (void)notificationRegEvent:(NSNotification *)notification {
    SipRegEvent *event = [notification object];
    if (event.code / 100 != 2) {
        NSLog(@"登录失败：code[%d] reason[%@]", event.code, event.reason);
        return;
    }
    NSLog(@"登录成功");
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        MainViewController *vc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
//        [self.navigationController pushViewController:vc animated:YES];
//    });
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

@end
