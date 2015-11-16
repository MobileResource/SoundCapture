//
//  RecordViewController.m
//  SoundCapture
//
//  Created by choe on 4/25/15.
//  Copyright (c) 2015 bong. All rights reserved.
//

#import "RecordViewController.h"
#import "Define.h"
#import "SelectRangeViewController.h"
#import "Common.h"


@interface RecordViewController ()

@property (nonatomic, strong) NSTimer *procTimer;
@property (nonatomic) float watchValue;
@end

@implementation RecordViewController
@synthesize microphone;
@synthesize recorder;


#pragma mark - Initialize View Controller Here
-(void)initializeViewController {
    // Create an instance of the microphone and tell it to use this view controller instance as the delegate
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    [self initializeViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initializeControls];
    [self.microphone startFetchingAudio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.microphone stopFetchingAudio];
    //self.microphone = [EZMicrophone microphoneWithDelegate:nil];
    if (self.recorder) {
        [self.recorder closeAudioFile];
        self.recorder = nil;
    }
    
}

- (IBAction)onDone:(id)sender {
    [self finishProc];
}

- (IBAction)onStart:(id)sender {
    _watchValue = 10.0f;
    _procTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onProcess:) userInfo:nil repeats:YES];
    _lblDescription.text = TEXT_TAP_DONE_RECORD;
    _btnStart.hidden = YES;
    _btnDone.hidden = NO;
    _lblHint.hidden = YES;
    _lblWatchTime.hidden = NO;
    [self startProc];
}

- (void)onProcess : (NSTimer *) timer {
    _watchValue -= 0.1;
    if (_watchValue <= 0) {
        [self finishProc];
    }
    else {
        _lblWatchTime.text = [NSString stringWithFormat:@"%.1f sec", _watchValue];
    }
        
}

- (void) startProc {
    /*
     Log out where the file is being written to within the app's documents directory
     */
    NSLog(@"File written to application sandbox's documents directory: %@",[self testFilePathURL]);
    
    if (!self.recorder) {
        self.recorder = [EZRecorder recorderWithDestinationURL:[self testFilePathURL]
                                              sourceFormat:self.microphone.audioStreamBasicDescription
                                       destinationFileType:EZRecorderFileTypeWAV];//EZRecorderFileTypeM4A
    }
    
    self.isRecording = YES;

}

- (void)finishProc {
    [_procTimer invalidate];
    [self initializeControls];
    
    self.isRecording = NO;
    
    if (self.recorder) {
        [self.recorder closeAudioFile];
        self.recorder = nil;
    }
    
    
    SelectRangeViewController * selRanger = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectRangeViewController"];
    [selRanger setSrcFile:[self testFilePathURL]];
    [self.navigationController pushViewController:selRanger animated:YES];
   // [self.navigationController performSegueWithIdentifier:@"pushSelRange3" sender:self];
}

- (void)initializeControls {
    _btnDone.hidden = YES;
    _lblWatchTime.hidden = YES;
    _btnStart.hidden = NO;
    _lblHint.hidden = NO;
    _lblDescription.text = TEXT_TAP_START_RECORD;
    
}

#pragma mark - Utility


-(NSURL*)testFilePathURL {
    return [Common withFilePathURL:kAudioFilePath extension:@"wav"];
}

#pragma mark - EZMicrophoneDelegate
#warning Thread Safety
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.

}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder. This is happening on the audio thread - any UI updating needs a GCD main queue block. This will keep appending data to the tail of the audio file.
    if( self.isRecording ){
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
    
}

@end
