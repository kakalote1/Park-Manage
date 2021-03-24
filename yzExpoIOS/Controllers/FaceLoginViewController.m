//
//  FaceLoginViewController.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/3/18.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "FaceLoginViewController.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, AVCamSetupResult) {
    AVCamSetupResultSuccess,
    AVCamSetupResultCameraNotAuthorized,
    AVCamSetupResultSessionConfigurationFailed
};

@interface FaceLoginViewController () <UIImagePickerControllerDelegate>
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

@property (nonatomic, strong)AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;

// 用来展示拍照获取的照片

@property (nonatomic, strong)UIImageView *imageShowView;

@property (nonatomic,strong) UIView *overlayView;

@property (nonatomic) dispatch_queue_t sessionQueue;

@property (nonatomic) AVCamSetupResult setupResult;


@end

@implementation FaceLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建界面
    [self makeUI];

    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;// 此处是关键。
    self.imagePicker.delegate = self;
    self.cameraVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [self presentViewController:self.imagePicker animated:YES completion:nil];
    [self.previewView addSubview:self.cameraVIew];
    [self configureSession];
}

#pragma mark --- 创建UI界面
-(void)makeUI
{
    self.previewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.previewView];
    
    //提示框
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-75, self.view.frame.size.height-64-120, 150, 30)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.backgroundColor = [UIColor lightGrayColor];
    self.textLabel.layer.cornerRadius = 15;
    self.textLabel.text = @"请按提示做动作";
    self.textLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.textLabel];
    
    //背景View
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    backView.backgroundColor = [UIColor lightGrayColor];
    
    //图片放置View
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.width*4/3)];
    [backView addSubview:imageView];
    
    //button上传图片
    [self buttonWithTitle:@"上传图片" frame:CGRectMake(self.view.frame.size.width/2-150, CGRectGetMaxY(imageView.frame)+10, 100, 30) action:@selector(didClickUpPhoto) AddView:backView];
    
    //重拍图片按钮
    [self buttonWithTitle:@"重拍" frame:CGRectMake(self.view.frame.size.width/2+50, CGRectGetMaxY(imageView.frame)+10, 100, 30) action:@selector(didClickPhotoAgain) AddView:backView];
}

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
    [self initCameraShowView];
    [self.view addSubview:self.overlayView];

    [self setUpCameraLayer];
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
}

- (void)initCameraShowView
{
    
    self.cameraVIew = [[UIView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.cameraVIew];
}


#pragma mark --- 创建button公共方法
/**使用示例:[self buttonWithTitle:@"点 击" frame:CGRectMake((self.view.frame.size.width - 150)/2, (self.view.frame.size.height - 40)/3, 150, 40) action:@selector(didClickButton) AddView:self.view];*/
-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.backgroundColor = [UIColor lightGrayColor];
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

- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}



- (void)configureSession{
   
    if ( self.setupResult != AVCamSetupResultSuccess ) {
        return;
    }
    
    [self.session beginConfiguration];//保证对AVCaptureSession设置的原子性与commitConfiguration配对使用

    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
     // 输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,@(0.1),AVVideoQualityKey,nil];
    
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput])
    {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput])
    {
        [self.session addOutput:self.stillImageOutput];
    }
    [self.session commitConfiguration];
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = CGRectMake((self.view.frame.size.width-200)/2.0, 150, 200, 200);
    self.previewLayer.cornerRadius = 100;
    self.previewLayer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    self.previewLayer.borderWidth = 3;
    //        preview?.frame = self.view.bounds
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.session startRunning];
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
