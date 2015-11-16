//
//  RecordViewController.h
//  SoundCapture
//
//  Created by choe on 4/25/15.
//  Copyright (c) 2015 bong. All rights reserved.
//

#import <UIKit/UIKit.h>
// Import EZAudio header
#import "EZAudio.h"

// Import AVFoundation to play the file (will save EZAudioFile and EZOutput for separate example)
#import <AVFoundation/AVFoundation.h>

// By default this will record a file to the application's documents directory (within the application's sandbox)
#define kAudioFilePath @"EZAudioTest"

@interface RecordViewController : UIViewController <EZMicrophoneDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblHint;
@property (weak, nonatomic) IBOutlet UILabel *lblWatchTime;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
- (IBAction)onDone:(id)sender;
- (IBAction)onStart:(id)sender;

/**
 A flag indicating whether we are recording or not
 */
@property (nonatomic,assign) BOOL isRecording;

/**
 The microphone component
 */
@property (nonatomic, strong) EZMicrophone *microphone;

/**
 The recorder component
 */
@property (nonatomic, strong) EZRecorder *recorder;

@end
