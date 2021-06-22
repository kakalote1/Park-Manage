//
//  FaceLoginViewController.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/3/18.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "FaceLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"

//是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define kIs_iPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0f ||[UIScreen mainScreen].bounds.size.height == 896.0f ||[UIScreen mainScreen].bounds.size.height == 844.0f ||[UIScreen mainScreen].bounds.size.height == 926.0f)

#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 44.f : 20.f)


typedef NS_ENUM(NSInteger, AVCamSetupResult) {
    AVCamSetupResultSuccess,
    AVCamSetupResultCameraNotAuthorized,
    AVCamSetupResultSessionConfigurationFailed
};

@interface FaceLoginViewController () <UIImagePickerControllerDelegate,AVCapturePhotoCaptureDelegate>
{
    UIView *backView;//照片背景
    UIImageView *imageView;//照片展示
    BOOL lightOn;
    AVCaptureDevice *device;
    UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain ) UIView         *previewView;
@property (nonatomic, strong ) UILabel        *textLabel;
@property (nonatomic, strong ) UIView *cameraVIew;
@property (nonatomic, strong ) UIImagePickerController *imagePicker;


@property (nonatomic, strong)AVCaptureSession *session;
// AVCaptureDeviceInput对象是输入流

@property (nonatomic, strong)AVCaptureDeviceInput *videoInput;

// 照片输出流对象

@property (nonatomic, strong)AVCapturePhotoOutput *imageOutput;

@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;

// 用来展示拍照获取的照片

@property (nonatomic, strong)UIImageView *imageShowView;

@property (nonatomic,strong) UIView *overlayView;

@property (nonatomic) dispatch_queue_t sessionQueue;

@property (nonatomic) AVCamSetupResult setupResult;

@property (nonatomic, strong) UserModel *userModel;

@property (nonatomic, retain) NSString *code;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation FaceLoginViewController

- (void)viewDidLoad {
    NSLog(@"[UIScreen mainScreen].bounds.size.height: %f", [UIScreen mainScreen].bounds.size.height);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self haveFaceInfo];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureSession];

    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 150 , self.view.frame.size.height/7, 300, 50)];
    self.textLabel.text = @"请将脸正对摄像头";
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:self.textLabel];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 13.0f) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, 60, 40)];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView:)];
           down.direction=UISwipeGestureRecognizerDirectionDown;
           [self.view addGestureRecognizer:down];
    }

}

- (void)dismissView :(UIButton *) button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 创建UI界面
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initAll];
    }
    return self;
}

- (void)initAll{
    [self initialSession];
//    [self initCameraShowView];
//    [self.view addSubview:self.overlayView];
//
//    [self setUpCameraLayer];
}

- (void)setUpCameraLayer
{
    if (self.previewLayer == nil)
    {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        UIView * view = self.cameraVIew;
        
        CALayer * viewLayer = [view layer];
        
        // UIView的clipsToBounds属性和CALayer的setMasksToBounds属性表达的意思是一致的,决定子视图的显示范围。当取值为YES的时候，剪裁超出父视图范围的子视图部分，当取值为NO时，不剪裁子视图。
        
        [viewLayer setMasksToBounds:YES];
        
        CGRect bounds = [view bounds];
        
        [self.previewLayer setFrame:bounds];
        
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        
        [viewLayer addSublayer:self.previewLayer];
    }
}


- (void)initialSession
{
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
}

- (void)initCameraShowView
{
    
    self.cameraVIew = [[UIView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.cameraVIew];
}


#pragma mark --- 创建butbuttonWithTitleton公共方法
/**使用示例:[self buttonWithTitle:@"点 击" frame:CGRectMake((self.view.frame.size.width - 150)/2, (self.view.frame.size.height - 40)/3, 150, 40) action:@selector(didClickButton) AddView:self.view];*/
-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [view addSubview:button];
    return button;
}

// 这是获取前后摄像头对象的方法

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *captureDevice in devices)
    {
        if (captureDevice.position == position)
        {
            return captureDevice;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (void)configureSession{
   
    if ( self.setupResult != AVCamSetupResultSuccess ) {
        return;
    }
    
    [self.session beginConfiguration];//保证对AVCaptureSession设置的原子性与commitConfiguration配对使用

    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:nil];
    
    self.imageOutput = [[AVCapturePhotoOutput alloc] init];
    
     // 输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
//    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecTypeJPEG,AVVideoCodecKey,@(0.1),AVVideoQualityKey,nil];
    
//    [self.imageOutput setOutputSettings:outputSettings];
    
//    [self.imageOutput capturePhotoWithSettings:AVVideoCodecTypeJPEG delegate:self];
    
    if ([self.session canAddInput:self.videoInput])
    {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.imageOutput])
    {
        [self.session addOutput:self.imageOutput];
    }
    [self.session commitConfiguration];
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = [UIScreen mainScreen].bounds;
//    self.previewLayer.frame = CGRectMake((self.view.frame.size.width-300)/2.0, 200, 300, 300);
//    self.previewLayer.cornerRadius = 150;
//    self.previewLayer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
//    self.previewLayer.borderWidth = 3;
    //        preview?.frame = self.view.bounds
    [self.view.layer addSublayer:self.previewLayer];
    [self.session startRunning];
    
    UIButton *takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *version = [UIDevice currentDevice].systemVersion;

    
    takeButton.frame = CGRectMake((self.view.frame.size.width - 70)/2, self.view.frame.size.height - 250, 70, 70);
    
    if (version.doubleValue < 13.0f) {
        takeButton.frame = CGRectMake((self.view.frame.size.width - 70)/2, self.view.frame.size.height * 0.7f, 70, 70);
    }
    takeButton.layer.masksToBounds = YES;
//    takeButton.layer.cornerRadius = takeButton.frame.size.height/2;
    takeButton.backgroundColor = [UIColor clearColor];
    
    
//    [takeButton setTitle:@"拍照" forState:UIControlStateNormal];
    [takeButton setBackgroundImage:[UIImage imageNamed:@"faceLogin"] forState:UIControlStateNormal];
//    takeButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    takeButton.titleLabel.numberOfLines = 0;
    [takeButton setTitleColor:[UIColor colorWithRed:40.2f/255 green:180.2f/255 blue:247.2f/255 alpha:0.9] forState:UIControlStateNormal];
    [takeButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeButton];
    
    UILabel *takeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, takeButton.frame.origin.y + 85, self.view.frame.size.width, 30)];
    takeLbl.text = @"开始识别";
    takeLbl.font = [UIFont systemFontOfSize:20];
    takeLbl.textAlignment = NSTextAlignmentCenter;
    takeLbl.textColor = [UIColor blackColor];
    [self.view addSubview:takeLbl];
}

- (void)takePhoto {
    NSLog(@"拍照拍照");
    [self.activityIndicator startAnimating];
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    [self.imageOutput capturePhotoWithSettings:outputSettings delegate:self];
}
// 拍照
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error
{
    NSData *data = [photo fileDataRepresentation];
    
    UIImage *image = [UIImage imageWithData:data];
    
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    NSData *imgData = UIImageJPEGRepresentation(image, 0.2f);
    NSString *prefix = @"data:image/jpg;base64,";
    NSString *image_base64 = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];

//    NSData * showData = [[NSData alloc]initWithBase64EncodedString:image_base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    UIImage *showimage = [UIImage imageWithData:data];
//
//        UIImageWriteToSavedPhotosAlbum(showimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    image_base64 = [prefix stringByAppendingFormat:@"%@", image_base64];
    NSLog(@"图片数据: %@", image_base64);
    NSLog(@"code: %@", self.code);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [user objectForKey:@"accessToken"];

    // 有人脸数据
    if ([self.code  isEqual: @"0"]) {
        NSString *url = [FACE_LOGIN_URL stringByAppendingFormat:@"%@", accessToken];
        NSDictionary *param = @{@"GroupIds" : @[@"yzExpo-App"] , @"Image": image_base64};
        [[HttpManager shareInstance] postRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
            NSDictionary *data = responseObject[@"data"];
            NSLog(@"识别: %@",data);
            NSInteger score = [[data objectForKey:@"score"] integerValue];
            NSLog(@"score: %ld", (long)score);
                    if (score >= 60) {
                        NSString *uid = [user objectForKey:@"uid"];
                        
                        if ([uid isEqualToString:data[@"uid"]]) {
                            [self dismissViewControllerAnimated:YES completion:^{
                                [self.activityIndicator stopAnimating];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:self userInfo:@{@"push":@"push"}];
                                [[UserModel shareInstance] initWithDic:responseObject[@"data"]];
                            }];
                            
                            
                        } else {
                            [self.view makeToast:@"请本人进行人脸识别登录"];
                        }
                      
                        [self.activityIndicator stopAnimating];
                    } else {
                        [self.activityIndicator stopAnimating];
                        [self.view makeToast:@"验证失败，请重新验证"];
                        [self.activityIndicator stopAnimating];

                    }
                } andFail:^(id error) {
                    [self.activityIndicator stopAnimating];
                    [self.view makeToast:@"验证失败，请稍后再试"];
                    [self.activityIndicator stopAnimating];

                }];
    }
    // 没有人脸数据
    else if ([self.code  isEqual: @"1"]) {
        NSString *url = [SAVE_FACE_URL stringByAppendingFormat:@"%@", accessToken];
        NSLog(@"Person: %@, %@", [user objectForKey:@"username"], [user objectForKey:@"uid"]);
        NSDictionary *param  =@{@"GroupId": @"yzExpo-App", @"PersonName": [user objectForKey:@"username"], @"PersonId": [user objectForKey:@"uid"], @"Gender": @0, @"Image": image_base64};
        NSLog(@"saveparam: %@", param);
        [[HttpManager shareInstance] postRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
            NSInteger ret = [responseObject[@"ret"] integerValue];
            NSLog(@"录入人脸: %ld", (long)ret);
            if (ret == 0 ) {
                [[UserModel shareInstance] initWithDic:responseObject[@"data"]];
                ViewController *vc = [[ViewController alloc] init];
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.activityIndicator stopAnimating];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:self userInfo:@{@"push":@"push"}];
                }];
            } else {
                [self.activityIndicator stopAnimating];
                [self.view makeToast:@"人脸录入失败，请重新录入"];
            }
        } andFail:^(id error) {
            [self.activityIndicator stopAnimating];
            [self.view makeToast:@"人脸录入失败，请稍后重试"];
            NSLog(@"error: %@", error);
        }];
    }
}

- (void)haveFaceInfo {
    if (!self.code) {
        self.code = [NSString new];
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [user objectForKey:@"accessToken"];
    NSString *url = [FACE_INFO_URL stringByAppendingFormat:@"%@", accessToken];
    NSString *uid = [user objectForKey:@"uid"];
    NSLog(@"uid: %@", uid);
    NSLog(@"accessToken: %@", accessToken);
    NSDictionary *param = @{@"uid" : uid};
    [[HttpManager shareInstance] postRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
            NSInteger errorcode = [responseObject[@"errorcode"] integerValue];
        NSLog(@"errorcode: %@", responseObject);
            if (errorcode == 0) {
                NSInteger ret = [responseObject[@"ret"] integerValue];
                NSLog(@"ret: %@", responseObject[@"ret"]);
                if (ret == 0)
                {
                    [self.view makeToast:@"正在进行人脸识别"];
                    self.code = @"0";
                } else {
                    self.code = @"1";
                    [self.view makeToast:@"您还没有录入人脸"];
                }
            } else {
                [self dismissViewControllerAnimated:YES completion:^{
                                [self.view makeToast:@"人脸识别异常，请稍后重试"];
                }];
            }
            
        } andFail:^(id error) {
            self.code = @"2";
            [self dismissViewControllerAnimated:YES completion:^{
                            [self.view makeToast:@"请重新登录"];
            }];
        }];
    NSLog(@"asdkjnqwdj: %@", self.code);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"+++++++++++%@", msg);
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
        _activityIndicator.backgroundColor = [UIColor colorWithWhite:0.33 alpha:0.9];
        _activityIndicator.layer.cornerRadius = 10.0f;
        _activityIndicator.hidesWhenStopped = YES;
          //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
//          _activityIndicator.hidesWhenStopped = NO;
        [self.view addSubview:_activityIndicator];
    }

    return _activityIndicator;
  
}

- (UserModel *)userModel {
    if (!_userModel) {
        _userModel = [UserModel shareInstance];
    }
    return _userModel;
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
