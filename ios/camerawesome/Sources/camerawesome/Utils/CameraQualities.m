//
//  CameraQualities.m
//  camerawesome
//
//  Created by Dimitri Dessus on 24/07/2020.
//

#import "CameraQualities.h"

// TODO: rework how qualities are working to be more easy
@implementation CameraQualities

+ (AVCaptureSessionPreset)selectVideoCapturePreset:(CGSize)size session:(AVCaptureSession *)session device:(AVCaptureDevice *)device {
  if (!CGSizeEqualToSize(CGSizeZero, size)) {
    AVCaptureSessionPreset bestPreset = [CameraQualities selectPresetForSize:size session:session];
    if (bestPreset != nil && [session canSetSessionPreset:bestPreset]) {
      return bestPreset;
    }
  }
  
  return [self computeBestPresetWithSession:session device:device];
}

+ (NSString *)selectVideoCapturePreset:(AVCaptureSession *)session device:(AVCaptureDevice *)device {
  return [self computeBestPresetWithSession:session device:device];
}

+ (CGSize)getSizeForPreset:(NSString *)preset {
  if (preset == AVCaptureSessionPreset3840x2160) {
    return CGSizeMake(3840, 2160);
  } else if (preset == AVCaptureSessionPreset1920x1080) {
    return CGSizeMake(1920, 1080);
  } else if (preset == AVCaptureSessionPreset1280x720) {
    return CGSizeMake(1280, 720);
  } else if (preset == AVCaptureSessionPreset640x480) {
    return CGSizeMake(640, 480);
  } else if (preset == AVCaptureSessionPreset352x288) {
    return CGSizeMake(352, 288);
  } else {
    // Default to HD
    return CGSizeMake(1280, 720);
  }
}

+ (AVCaptureSessionPreset)computeBestPresetWithSession:(AVCaptureSession *)session device:(AVCaptureDevice *)device {
  NSArray *qualities = [CameraQualities captureFormatsForDevice:device];
  
  /*for (PreviewSize *quality in qualities) {
    CGSize qualitySize = CGSizeMake([quality.width floatValue], [quality.height floatValue]);
    NSLog(@"🎯 Focus: qualitySize %@", NSStringFromCGSize(qualitySize));
  }*/

  for (PreviewSize *quality in qualities) {
    CGSize qualitySize = CGSizeMake([quality.width floatValue], [quality.height floatValue]);
    AVCaptureSessionPreset currentPreset = [CameraQualities selectPresetForSize:qualitySize session:session];
    
    if (currentPreset != nil && [session canSetSessionPreset:currentPreset]) {
      //NSLog(@"🎯 Focus: currentPreset %@", currentPreset);
      return currentPreset;
    }
  }
  
  // Default to HD
  return AVCaptureSessionPreset1280x720;
}

+ (NSString *)selectPresetForSize:(CGSize)size session:(AVCaptureSession *)session {
  //return AVCaptureSessionPreset1920x1080;
  if (size.width >= 2160 || size.height >= 3840) {
    if (@available(iOS 9.0, *)) {
      // we don't know the exact size, so we check if it can apply
      // if not, apply basic 1920x1080
      if ([session canSetSessionPreset:AVCaptureSessionPreset3840x2160]) {
        return AVCaptureSessionPreset3840x2160;
      } else {
        return AVCaptureSessionPreset1920x1080;
      }
      return AVCaptureSessionPreset3840x2160;
    } else {
      return AVCaptureSessionPreset1920x1080;
    }
  } else if (size.width == 1080 && size.height == 1920) {
    return AVCaptureSessionPreset1920x1080;
  } else if (size.width == 720 && size.height == 1280) {
    return AVCaptureSessionPreset1280x720;
  } else if (size.width == 480 && size.height == 640) {
    return AVCaptureSessionPreset640x480;
  } else if (size.width == 288 && size.height == 352) {
    return AVCaptureSessionPreset352x288;
  } else {
    return nil;
  }
}

+ (NSArray *)captureFormatsForDevice:(AVCaptureDevice *)device  {
  NSMutableArray *qualities = [[NSMutableArray alloc] init];
  NSArray<AVCaptureDeviceFormat *>* formats = [device formats];
  for(int i = 0; i < formats.count; i++) {
    AVCaptureDeviceFormat *format = formats[i];
    /*NSMutableArray<NSString *> *supportedModes = [[NSMutableArray alloc] init];
    if ([format isVideoStabilizationModeSupported:AVCaptureVideoStabilizationModeStandard]) {
      [supportedModes addObject:@"AVCaptureVideoStabilizationModeStandard"];
    }
    if ([format isVideoStabilizationModeSupported:AVCaptureVideoStabilizationModeCinematic]) {
      [supportedModes addObject:@"AVCaptureVideoStabilizationModeCinematic"];
    }

    if ([format isVideoStabilizationModeSupported:AVCaptureVideoStabilizationModeCinematicExtended]) {
      [supportedModes addObject:@"AVCaptureVideoStabilizationModeCinematicExtended"];
    }

    if ([format isVideoStabilizationModeSupported:AVCaptureVideoStabilizationModeCinematicExtendedEnhanced]) {
      [supportedModes addObject:@"AVCaptureVideoStabilizationModeCinematicExtendedEnhanced"];
    }

    NSLog(@"🎯 Stabilization: format %d:%d supported modes %@", CMVideoFormatDescriptionGetDimensions(format.formatDescription).width, CMVideoFormatDescriptionGetDimensions(format.formatDescription).height, supportedModes);
    
    NSLog(@"🎯 Stabilization: format %@", format);

    NSLog(@"🎯 Stabilization: format frame rate %@", format.videoSupportedFrameRateRanges);
    [qualities addObject:
       [PreviewSize makeWithWidth:[NSNumber numberWithDouble:CMVideoFormatDescriptionGetDimensions(format.formatDescription).width] height:[NSNumber numberWithDouble:CMVideoFormatDescriptionGetDimensions(format.formatDescription).height]]
    ];*/
    if ([format isVideoStabilizationModeSupported:AVCaptureVideoStabilizationModeStandard]) {
      [qualities addObject:
        [PreviewSize makeWithWidth:[NSNumber numberWithDouble:CMVideoFormatDescriptionGetDimensions(format.formatDescription).width] height:[NSNumber numberWithDouble:CMVideoFormatDescriptionGetDimensions(format.formatDescription).height]]
      ];
    }
  }
  NSEnumerator *reverseEnumerator = [qualities reverseObjectEnumerator];
  NSArray *reversedArray = [reverseEnumerator allObjects];
  return reversedArray;
}

@end
