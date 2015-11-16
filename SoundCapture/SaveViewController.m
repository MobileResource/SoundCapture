//
//  SaveViewController.m
//  SoundCapture
//
//  Created by choe on 4/27/15.
//  Copyright (c) 2015 bong. All rights reserved.
//

#import "SaveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+Starlet.h"
#import "Common.h"

@implementation SaveViewController

-(void) viewDidLoad {
    _txtFilename.text = @"test";
}
- (IBAction)onSave:(id)sender {
    NSString * filename = _txtFilename.text;
    if ([self validateFileName:filename]) {
        [self trimAudio];
    }
}

- (BOOL) validateFileName : (NSString *) filename {
    
    if (!filename) {
        return false;
    }
    if ([filename isEqualToString:@""]) {
        return false;
    }
    
    
    return true;
}


- (BOOL)trimAudio
{
    float vocalStartMarker = _startMarker;
    float vocalEndMarker = _endMarker;
    
    NSURL *audioFileInput = _srcFile;
    NSURL *audioFileOutput = [self outputPathURL];
    
    if (!audioFileInput || !audioFileOutput)
    {
        return NO;
    }
    
    

    [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
    AVAsset *asset = [AVAsset assetWithURL:audioFileInput];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset
                                                                            presetName:AVAssetExportPresetAppleM4A];
    
    if (exportSession == nil)
    {
        return NO;
    }
    
    CMTime startTime = CMTimeMake((int)(floor(vocalStartMarker * 100)), 100);
    CMTime stopTime = CMTimeMake((int)(ceil(vocalEndMarker * 100)), 100);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
    
    exportSession.outputURL = audioFileOutput;
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = exportTimeRange;

    [self showHUD];

    [exportSession exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (AVAssetExportSessionStatusCompleted == exportSession.status)
             {
                 [self hideHUD];
                 unsigned long long fileSize = 0;
                 if (audioFileOutput.isFileURL) {
                     NSString *file = audioFileOutput.path;
                     NSError *err = nil;
                     if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
                         NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:&err];
                         fileSize = [attributes fileSize];
                     }
                 }
                 NSLog(@"%@.wav is saved successfully!", _txtFilename.text);

                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succcess!"
                                                                 message:[NSString stringWithFormat:@"%@.wav is saved successfully!\nduration:%.2f~%.2fsec\nfilesize:%lluByte", _txtFilename.text, _startMarker, _endMarker, fileSize]
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
             else if (AVAssetExportSessionStatusFailed == exportSession.status)
             {
                 [self hideHUD];
                 // It failed...
                 NSLog(@"%@.wav is failed!", _txtFilename.text);
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail!"
                                                                message:[NSString stringWithFormat:@"%@.wav is failed to save!", _txtFilename.text]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                 [alert show];
             }
         });
     }];
    
    return YES;
}

#pragma mark - Utility

-(NSURL*)outputPathURL {
    return [Common withFilePathURL:_txtFilename.text extension:@"m4a"];
}

#pragma mark - AVAudioPlayerDelegate
/*
 Occurs when the audio player instance completes playback
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.audioPlayer = nil;
}

@end
