//
//  MetaQR.m
//  MetaQR-Example
//
//  Created by DilumNavanjana on 4/5/14.
//  Copyright (c) 2014 DilumNavanjana. All rights reserved.
//

#import "MetaQR.h"

@interface MetaQR ()
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation MetaQR

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _session = [[AVCaptureSession alloc] init];
        
        _session = [[AVCaptureSession alloc] init];
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        
        // Display full screen
        previewLayer.frame = CGRectMake(0,0,320,480);
        
        // Add the video preview layer to the view
        [self.layer addSublayer:previewLayer];
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                            error:&error];
        if (input) {
            [_session addInput:input];
        } else {
            NSLog(@"Error: %@", error);
        }
        
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_session addOutput:output];
        
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code]];
        
        [_session startRunning];

    }
    return self;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    _QRCode = nil;
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            _QRCode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }
    }
    [_session stopRunning];
    [self removeFromSuperview];
    
    NSLog(@"QR Code: %@", _QRCode);
}

@end
