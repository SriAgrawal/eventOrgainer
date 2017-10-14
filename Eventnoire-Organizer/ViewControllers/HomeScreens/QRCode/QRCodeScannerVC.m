//
//  QRCodeScannerVC.m
//  Eventnoire-Organizer
//
//  Created by Aiman Akhtar on 12/04/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "NSDictionary+NullChecker.h"
#import "RequestTimeOutView.h"
#import "RequestTimeOutView.h"
#import "QRCodeScannerVC.h"
#import "ServiceHelper.h"
#import "AlertController.h"
#import "Macro.h"

@interface QRCodeScannerVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *codeScannerView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

@end

@implementation QRCodeScannerVC

#pragma mark - UIViewController Life Cycle & Memory Management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method

- (void)initialSetup {
    
    self.scanLabel.hidden = YES;
    NSError *error;

    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        [RequestTimeOutView showWithMessage:[error localizedDescription] forTime:2.0];
        return;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.codeScannerView.layer.bounds];
    [self.codeScannerView.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            self.scanLabel.text = [metadataObj stringValue];
            [self findOccurenceOfString];
            
            [_captureSession stopRunning];
          //  _captureSession = nil;
        }
    }
}


-(void)findOccurenceOfString {
    NSUInteger count = 0, length = [self.scanLabel.text length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [self.scanLabel.text rangeOfString: @"__" options:0 range:range];
        if(range.location != NSNotFound){
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
        }
    }
    
    
    if (count != 2) {
        [AlertController title:@"" message:@"Invalid QR code" andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if (index == 0){
                [_captureSession startRunning];
            }
        }];

    }else{
        NSArray *scannedDataArray = [self.scanLabel.text componentsSeparatedByString:@"__"];

        [self verificationRequest:scannedDataArray];
    }
}


#pragma mark - UIButton Action Methods

- (IBAction)backButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)verificationRequest:(NSArray *)scannedDataArray {
    
    NSMutableDictionary *verificationDict = [NSMutableDictionary new];
    
    [verificationDict setValue:[scannedDataArray firstObject] forKey:pUserID];
    [verificationDict setValue:([scannedDataArray count] > 1)?[scannedDataArray objectAtIndex:1]:[NSString string] forKey:pVerificationEventId];
    [verificationDict setValue:[scannedDataArray lastObject] forKey:pVerificationTicketId];
    
    [verificationDict setValue:self.scanLabel.text forKey:pVerificationQrcode];
    
    [self apiCallForVerification:verificationDict andServiceName:scanVerificationAPI];
}

-(void)apiCallForVerification:(NSMutableDictionary *)verificationDict andServiceName:(NSString *)serviceName {
    
    [[ServiceHelper sharedServiceHelper] callApiWithParameter:verificationDict apiName:serviceName andApiType:POST andIsRequiredHud:YES WithComptionBlock:^(NSDictionary *result, NSError *error) {
        
        if (!error) {
            NSString *successMessage = [result objectForKeyNotNull:pResponseMessage expectedObj:[NSString string]];

            [AlertController title:@"" message:successMessage andButtonsWithTitle:@[@"OK"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                if (index == 0){
                    [_captureSession startRunning];
                }
            }];
            
        }else if (error.code == 100) {
            //Success but other than 200 responseCode
            NSString *errorMessage = [result objectForKeyNotNull:pResponseMessage expectedObj:[NSString string]];
            [RequestTimeOutView showWithMessage:errorMessage forTime:2.0];
            
            [_captureSession startRunning];
        }else {
            //Error
            NSString *errorMessage = error.localizedDescription;
            [RequestTimeOutView showWithMessage:errorMessage forTime:2.0];
            [_captureSession startRunning];
        }
    }];
}

@end
