//
//  LoginViewController.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/3/15.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import "UIView+Toast.h"
#import <WebKit/WebKit.h>
#import "FaceLoginViewController.h"
#import "HttpManager.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "UserModel.h"
#import "ViewController.h"

//是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define kIs_iPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0f ||[UIScreen mainScreen].bounds.size.height == 896.0f ||[UIScreen mainScreen].bounds.size.height == 844.0f ||[UIScreen mainScreen].bounds.size.height == 926.0f)

#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)

#define  kTabbarSafeBottomMargin        (kIs_iPhoneX ? 34.f : 0.f)

#define affsetHeight 250

#define HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]

@interface LoginViewController () <UITextFieldDelegate, WKScriptMessageHandler>
{
    CGFloat maxY;
    BOOL isShowKeyboard;
}

@property (strong, nonatomic) UIView *topImgVc;
@property (strong, nonatomic) UIView *bottomImgVc;

@property (strong, nonatomic) UIView *warningLine;

@property (strong, nonatomic) UIView *usernameImgVc;
@property (strong, nonatomic) UIView *passwordImgVc;

@property (strong, nonatomic) UILabel *titleLbl;

@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *passwordField;

@property (strong, nonatomic) UIButton *loginButton;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) WKWebViewConfiguration *wkWebViewConfiguration;
@property (nonatomic, strong) WKUserContentController *wkUserContentController;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //配置wkWebViewConfiguration
    [self wkConfiguration];
    
    //OC注册供JS调用的方法
    [self addScriptFunction];
    
    [self.view endEditing:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *topImg = [UIImage imageNamed:@"login_top"];

    self.topImgVc = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75, kStatusBarAndNavigationBarHeight, 150, 150)];
//    self.topImgVc.backgroundColor = [UIColor colorWithPatternImage:topImg];
    self.topImgVc.layer.contents = (__bridge id _Nullable)(topImg.CGImage);
    [self.view addSubview:self.topImgVc];
    
    self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topImgVc.frame.origin.y + 180, self.view.frame.size.width, 40)];
    self.titleLbl.text = @"扬州世界园艺博览会";
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.textColor = [UIColor blackColor];
    self.titleLbl.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
    [self.view addSubview:self.titleLbl];
    
    self.usernameImgVc = [[UIView alloc] initWithFrame:CGRectMake(40, self.titleLbl.frame.origin.y + 100, self.view.frame.size.width - 80, 45)];
    self.usernameImgVc.backgroundColor = [UIColor systemGray6Color];
    UIImageView *usernameImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_username"]];
    usernameImgV.frame = CGRectMake(20, 10, 25, 25);
    usernameImgV.contentMode = UIViewContentModeScaleAspectFit;
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, self.usernameImgVc.frame.size.width - 80, 45)];
//    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.borderStyle = UITextBorderStyleNone;
    self.usernameField.backgroundColor = [UIColor clearColor];
    self.usernameField.placeholder = @"请输入用户名";
    self.usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameField.delegate = self;
    [self.usernameField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.usernameImgVc.layer.cornerRadius = 7;
    [self.usernameImgVc addSubview:usernameImgV];
    [self.usernameImgVc addSubview: self.usernameField];
    [self.view addSubview: self.usernameImgVc];
    
    self.passwordImgVc = [[UIView alloc] initWithFrame:CGRectMake(40, self.usernameImgVc.frame.origin.y + 65, self.view.frame.size.width - 80, 45)];
    self.passwordImgVc.backgroundColor = [UIColor systemGray6Color];
    UIImageView *passwordImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
    passwordImgV.frame = CGRectMake(20, 10, 25, 25);
    passwordImgV.contentMode = UIViewContentModeScaleAspectFit;
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, self.passwordImgVc.frame.size.width - 80, 45)];
    self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.placeholder = @"请输入密码";
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.secureTextEntry = TRUE;
    self.passwordField.delegate = self;
    [self.passwordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.passwordImgVc.layer.cornerRadius = 7;
    [self.passwordField resignFirstResponder];
    [self.passwordImgVc addSubview: passwordImgV];
    [self.passwordImgVc addSubview: self.passwordField];
    [self.view addSubview: self.passwordImgVc];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:88/255.0 green:112/255.0 blue:248/255.0 alpha:1.0]] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [UIColor systemBlueColor];
//    [self.loginButton setBackgroundColor:[UIColor colorWithRed:88/255.0 green:112/255.0 blue:248/255.0 alpha:1.0]];
    self.loginButton.frame = CGRectMake(40, self.passwordImgVc.frame.origin.y + 75, self.view.frame.size.width - 80, 45);
    
    
    self.loginButton.layer.cornerRadius = 10.0f ;
    
    self.loginButton.layer.masksToBounds = YES ;

    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.loginButton];
    
    UIImage *bottomImg = [UIImage imageNamed:@"login_bottom"];
    self.tap.delaysTouchesBegan = NO;
    
    self.bottomImgVc = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height -  self.view.frame.size.width * 0.386, self.view.frame.size.width, self.view.frame.size.width * 0.386)];
    self.bottomImgVc.layer.contents = (__bridge id _Nullable)(bottomImg.CGImage);
    [self.view addSubview:self.bottomImgVc];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:TRUE];
}

-(void)login:(UIButton *)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSLog(@"用户名: %@, 密码: %@", username, password);
    NSString *plistPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"userinfo.plist"];
    NSDictionary *dic2 = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"asdasdas");
    NSLog(@"%@\n%@",[dic2 objectForKey:@"accessToken"],PATH_OF_DOCUMENT);
    
    
    NSString *url = [@"http://toss.yzyby2018.com/usrv/user/admin/auth-by-account?access_token=" stringByAppendingFormat:@"%@", [dic2 objectForKey:@"accessToken"]];
    NSLog(@"url : %@", url);
    NSDictionary *param = @{@"account": username, @"password": password};
    NSLog(@"param: %@", param);
    [[HttpManager shareInstance] postRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
        NSInteger errorcode = [responseObject[@"errorcode"] integerValue];
        if (errorcode == 0) {
            [self.view makeToast:@"登录成功"];
            NSLog(@"登录成功");
            NSString *url = [@"http://toss.yzyby2018.com/usrv/user/admin/detail-by-username?access_token=" stringByAppendingFormat:@"%@", [dic2 objectForKey:@"accessToken"]];
            [[HttpManager shareInstance] postRequestWithUrl:url andParam:@{@"username":username} andHeaders:nil andSuccess:^(id responseObject) {
                UserModel *user = [[UserModel shareInstance] initWithDic:responseObject[@"data"]];
        
                NSLog(@"userinfo : %@", user.uid);
                
                ViewController *vc = [[ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                        } andFail:^(id error) {
                            
                        }];
        } else {
            NSString *message = responseObject[@"msg"];
            switch (errorcode) {
                case 11004:
                    [self.view makeToast:message];
                case 11027:
                    [self.view makeToast:message];
                case 10001:
                    [self.view makeToast:message];
                    break;
                    
                default:
                    [self.view makeToast:@"请输入用户名和密码"];
                    break;
            }
        }
        
        } andFail:^(id error) {
            
        
            
        }];
    

//    FaceLoginViewController *faceLoginVc = [[FaceLoginViewController alloc] init];
//    [self.navigationController pushViewController:faceLoginVc animated:YES];
}


//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
 
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
 
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    return image;
}

#pragma mark - hidden Keyboard
- (void)hiddenKeyboardForTap
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
}

- (void)returnOnKeyboard:(UITextField *)sender
{
    if (sender == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else if (sender == self.passwordField) {
        [self hiddenKeyboardForTap];
        if (self.loginButton.enabled) {
//            [self loginAction:_loginButton];
        }
    }
}

- (void)wkConfiguration {
    self.wkWebViewConfiguration = [[WKWebViewConfiguration alloc]init];
    
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    self.wkWebViewConfiguration.preferences = preferences;
    
}

#pragma mark -  OC注册供JS调用的方法
- (void)addScriptFunction {
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"login"];
}

#pragma mark --- WKScriptMessageHandler ---
//OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // 根据name做想做的操作
    //前端主动JS发送消息，前端指令动作
    if ([@"login" isEqualToString:message.name]) {
        [self login:message.body];
    }
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
