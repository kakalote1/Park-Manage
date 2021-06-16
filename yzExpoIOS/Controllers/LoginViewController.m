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
#import "FaceLoginViewController.h"
#import "HttpManager.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "UserModel.h"
#import "ViewController.h"
#import "UIView+Toast.h"

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

@interface LoginViewController () <UITextFieldDelegate>
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

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        NSLog(@"login uid: %@", uid);
        if (uid.length > 0 && ![uid isEqual: @"(null)"]) {

            if ([uid isEqualToString:@"14c14b43ad2a68520f38be24fc7330f9"]) {
                ViewController *vc = [[ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                //             人脸识别
                FaceLoginViewController *vc = [[FaceLoginViewController alloc] init];
                vc.modalPresentationStyle = UIModalPresentationPageSheet;
                [self presentViewController:vc animated:YES completion:nil];
            }

////
//            ViewController *vc = [[ViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
    });

}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.activityIndicator stopAnimating];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(handlePush:)
                   name:@"push"
                 object:nil];

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [self.view endEditing:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"屏幕size : %f", [UIScreen mainScreen].bounds.size.height);
    UIImage *topImg = [UIImage imageNamed:@"login_top"];

    self.topImgVc = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - self.view.frame.size.height / 6.5f) / 2, kStatusBarAndNavigationBarHeight, self.view.frame.size.height / 6.5f, self.view.frame.size.height / 6.5f)];
//    self.topImgVc.backgroundColor = [UIColor colorWithPatternImage:topImg];
    self.topImgVc.layer.contents = (__bridge id _Nullable)(topImg.CGImage);
    [self.view addSubview:self.topImgVc];
    
    if (568.0f == [UIScreen mainScreen].bounds.size.height) {
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topImgVc.frame.origin.y + self.topImgVc.frame.size.width + 20, self.view.frame.size.width, 30)];
        self.titleLbl.text = @"扬州世界园艺博览会";
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.textColor = [UIColor blackColor];
        self.titleLbl.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
        [self.view addSubview:self.titleLbl];
        self.usernameImgVc = [[UIView alloc] initWithFrame:CGRectMake(40, self.titleLbl.frame.origin.y + 45, self.view.frame.size.width - 80, 40)];
        self.usernameImgVc.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
        UIImageView *usernameImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_username"]];
        usernameImgV.frame = CGRectMake(20, 10, 20, 20);
        usernameImgV.contentMode = UIViewContentModeScaleAspectFit;
        self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, self.usernameImgVc.frame.size.width - 60, 40)];
    //    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
        self.usernameField.borderStyle = UITextBorderStyleNone;
        self.usernameField.backgroundColor = [UIColor clearColor];
        self.usernameField.placeholder = @"请输入用户名";
        self.usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.usernameField.delegate = self;
        if ([user objectForKey:@"username"]) {
            self.usernameField.text = [user objectForKey:@"username"];
        }
        [self.usernameField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        self.usernameImgVc.layer.cornerRadius = 7;
        [self.usernameImgVc addSubview:usernameImgV];
        [self.usernameImgVc addSubview: self.usernameField];
        [self.view addSubview: self.usernameImgVc];
        
        self.passwordImgVc = [[UIView alloc] initWithFrame:CGRectMake(40, self.usernameImgVc.frame.origin.y + 60, self.view.frame.size.width - 80, 40)];
        self.passwordImgVc.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
        UIImageView *passwordImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
        passwordImgV.frame = CGRectMake(20, 10, 20, 20);
        passwordImgV.contentMode = UIViewContentModeScaleAspectFit;
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, self.passwordImgVc.frame.size.width - 60, 40)];
        self.passwordField.borderStyle = UITextBorderStyleNone;
        self.passwordField.placeholder = @"请输入密码";
        self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordField.secureTextEntry = TRUE;
        self.passwordField.delegate = self;
        if ([user objectForKey:@"password"]) {
            self.passwordField.text = [user objectForKey:@"password"];
        }
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
        self.loginButton.frame = CGRectMake(40, self.passwordImgVc.frame.origin.y + 60, self.view.frame.size.width - 80, 35);
        
        
        self.loginButton.layer.cornerRadius = 10.0f ;
        
        self.loginButton.layer.masksToBounds = YES ;

        [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.loginButton];
    } else {
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topImgVc.frame.origin.y + self.topImgVc.frame.size.width + 30, self.view.frame.size.width, 40)];
        self.titleLbl.text = @"扬州世界园艺博览会";
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.textColor = [UIColor blackColor];
        self.titleLbl.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
        [self.view addSubview:self.titleLbl];
        self.usernameImgVc = [[UIView alloc] initWithFrame:CGRectMake(40, self.titleLbl.frame.origin.y + 70, self.view.frame.size.width - 80, 45)];
        self.usernameImgVc.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
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
        if ([user objectForKey:@"username"]) {
            self.usernameField.text = [user objectForKey:@"username"];
        }
        [self.usernameField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        self.usernameImgVc.layer.cornerRadius = 7;
        [self.usernameImgVc addSubview:usernameImgV];
        [self.usernameImgVc addSubview: self.usernameField];
        [self.view addSubview: self.usernameImgVc];
        
        self.passwordImgVc = [[UIView alloc] initWithFrame:CGRectMake(40, self.usernameImgVc.frame.origin.y + 65, self.view.frame.size.width - 80, 45)];
        self.passwordImgVc.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
        UIImageView *passwordImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
        passwordImgV.frame = CGRectMake(20, 10, 25, 25);
        passwordImgV.contentMode = UIViewContentModeScaleAspectFit;
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, self.passwordImgVc.frame.size.width - 80, 45)];
        self.passwordField.borderStyle = UITextBorderStyleNone;
        self.passwordField.placeholder = @"请输入密码";
        self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordField.secureTextEntry = TRUE;
        self.passwordField.delegate = self;
        if ([user objectForKey:@"password"]) {
            self.passwordField.text = [user objectForKey:@"password"];
        }
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
    }
    
    UIImage *bottomImg = [UIImage imageNamed:@"login_bottom"];
    self.tap.delaysTouchesBegan = NO;
    
    self.bottomImgVc = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height -  self.view.frame.size.width * 0.386, self.view.frame.size.width, self.view.frame.size.width * 0.386)];
    self.bottomImgVc.layer.contents = (__bridge id _Nullable)(bottomImg.CGImage);
    [self.view addSubview:self.bottomImgVc];
}

- (void) dealloc {

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:TRUE];
}

-(void)login:(UIButton *)sender {
    [self.activityIndicator startAnimating];
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSLog(@"用户名: %@, 密码: %@", username, password);
    NSString *plistPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"userinfo.plist"];
    NSDictionary *dic2 = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"asdasdas");
    NSLog(@"%@\n%@",[dic2 objectForKey:@"accessToken"],PATH_OF_DOCUMENT);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [user objectForKey:@"accessToken"];
    
    if (accessToken.length > 0 && ![accessToken isEqualToString:@"null"]) {
        NSString *url = [LOGIN_URL stringByAppendingFormat:@"%@", accessToken];
        NSLog(@"url : %@", url);
        NSDictionary *param = @{@"account": username, @"password": password};
        NSLog(@"param: %@", param);
        [[HttpManager shareInstance] postRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
            NSInteger errorcode = [responseObject[@"errorcode"] integerValue];
            if (errorcode == 0) {
                [self.activityIndicator stopAnimating];
                NSLog(@"登录成功");
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:username forKey:@"username"];
                [user setObject:password forKey:@"password"];
                NSString *url = [USER_INFO_URL stringByAppendingFormat:@"%@", accessToken];
                [[HttpManager shareInstance] postRequestWithUrl:url andParam:@{@"username":username} andHeaders:nil andSuccess:^(id responseObject) {
                    [self saveDevInfo];
                    UserModel *userModel = [[UserModel shareInstance] initWithDicWithoutSave:responseObject[@"data"]];
            
                    NSString *uid = userModel.uid;
                    NSLog(@"userinfo : %@", uid);
                    [user setObject:uid forKey:@"uid"];
                    [user setObject:username forKey:@"username"];
    //                ViewController *vc = [[ViewController alloc] init];
    //                [self.navigationController pushViewController:vc animated:YES];
    //                [self dismissViewControllerAnimated:YES completion:nil];
    //                [self.activityIndicator stopAnimating];
                    if ([uid isEqualToString:@"14c14b43ad2a68520f38be24fc7330f9"]) {
                        ViewController *vc = [[ViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    } else {
                        FaceLoginViewController *faceVc = [[FaceLoginViewController alloc] init];
        //                [self.navigationController pushViewController:faceVc animated:YES];
                        faceVc.modalPresentationStyle = UIModalPresentationPageSheet;
                        [self presentViewController:faceVc animated:YES completion:^{


                        }];
                    }
                    
                } andFail:^(id error) {
                                
                            }];
                
            } else {
                [self.activityIndicator stopAnimating];
                NSString *message = responseObject[@"msg"];
                switch (errorcode) {
                    case 11004:
                        [self.view makeToast:@"用户名或者密码错误"];
                    case 11027:
                        [self.view makeToast:@"用户名或者密码错误"];
                    case 10001:
                        [self.view makeToast:@"登录失败，请稍后重试"];
                        break;
                        
                    default:
                        [self.view makeToast:@"请输入用户名和密码"];
                        break;
                }
            }
            } andFail:^(id error) {
                [self.view makeToast:@"未获取到网络，请稍后重试"];
                [self.activityIndicator stopAnimating];
                
            }];
        
    } else {
        [[HttpManager shareInstance]postRequestWithUrl:@"https://service.yzyby2018.com/jiekou/common-api/common/login/getAccessToken" andParam:@{
            @"source": @"APP"} andHeaders:nil andSuccess:^(id responseObject) {
            NSLog(@"获取成功：%@", responseObject);
            NSString *str = responseObject[@"data"];
            NSLog(@"accessToken: %@",str);
            if (str.length > 0 && ![str isEqualToString:@"null"]) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:str forKey:@"accessToken"];
                NSLog(@"accessToken UserDefault: %@", [user objectForKey:@"accessToken"]);
                NSString *url = [LOGIN_URL stringByAppendingFormat:@"%@", str];
                NSLog(@"url : %@", url);
                NSDictionary *param = @{@"account": username, @"password": password};
                NSLog(@"param: %@", param);
                [[HttpManager shareInstance] postRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
                    NSInteger errorcode = [responseObject[@"errorcode"] integerValue];
                    if (errorcode == 0) {
            //            [self.view makeToast:@"登录成功"];
                        [self.activityIndicator stopAnimating];
                        NSLog(@"登录成功");
                        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                        [user setObject:username forKey:@"username"];
                        [user setObject:password forKey:@"password"];
                        NSString *url = [USER_INFO_URL stringByAppendingFormat:@"%@", accessToken];
                        [[HttpManager shareInstance] postRequestWithUrl:url andParam:@{@"username":username} andHeaders:nil andSuccess:^(id responseObject) {
                            [self saveDevInfo];
                            UserModel *userModel = [[UserModel shareInstance] initWithDicWithoutSave:responseObject[@"data"]];
                    
                            NSString *uid = userModel.uid;
                            NSLog(@"userinfo : %@", uid);
                            [user setObject:uid forKey:@"uid"];
                            [user setObject:username forKey:@"username"];
            //                ViewController *vc = [[ViewController alloc] init];
            //                [self.navigationController pushViewController:vc animated:YES];
            //                [self dismissViewControllerAnimated:YES completion:nil];
            //                [self.activityIndicator stopAnimating];
                            if ([uid isEqualToString:@"14c14b43ad2a68520f38be24fc7330f9"]) {
                                ViewController *vc = [[ViewController alloc] init];
                                [self.navigationController pushViewController:vc animated:YES];
                            } else {
                                FaceLoginViewController *faceVc = [[FaceLoginViewController alloc] init];
                //                [self.navigationController pushViewController:faceVc animated:YES];
                                faceVc.modalPresentationStyle = UIModalPresentationPageSheet;
                                [self presentViewController:faceVc animated:YES completion:^{


                                }];
                            }
                            
                        } andFail:^(id error) {
                                        
                                    }];
                        
                    } else {
                        [self.activityIndicator stopAnimating];
                        NSString *message = responseObject[@"msg"];
                        switch (errorcode) {
                            case 11004:
                                [self.view makeToast:@"用户名或者密码错误"];
                            case 11027:
                                [self.view makeToast:@"用户名或者密码错误"];
                            case 10001:
                                [self.view makeToast:@"登录失败，请稍后重试"];
                                break;
                                
                            default:
                                [self.view makeToast:@"请输入用户名和密码"];
                                break;
                        }
                    }
                    } andFail:^(id error) {
                        [self.view makeToast:@"未获取到网络，请稍后重试"];
                        [self.activityIndicator stopAnimating];

                        
                    }];
                
            } else {
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务异常，请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   NSLog(@"确定");
                }];
                [alter addAction:cancelAction];
                [alter addAction:okAction];
                [self.navigationController presentViewController:alter animated:YES completion:nil];
            }
                
        } andFail:^(id error) {
            [self.view makeToast:@"网络异常，请稍后重试"];
                }];
    }
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

// 登录成功后保存设备信息
- (void)saveDevInfo {
    NSString *devToken = [UserModel shareInstance].devToken;
    NSString *uid = [UserModel shareInstance].uid;
    if (devToken.length > 0 && uid.length > 0) {
        NSDictionary *param = @{@"uid": uid, @"loginUid": uid, @"devToken": devToken, @"devType": @"1"};
        NSString *url = @"http://58.220.201.130:12383/zlw/data/thirdPart/saveDevInfo";
        [[HttpManager shareInstance] getRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
                NSLog(@"关联设备成功: %@", responseObject);
            } andFail:^(id error) {
                
            }];
    }

}

- (void) handlePush: (NSNotification *) notification {
    NSLog(@"人脸通知回调: %@",[notification object]);
    [self.activityIndicator startAnimating];
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.activityIndicator stopAnimating];
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
