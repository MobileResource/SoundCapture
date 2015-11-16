//
//  SaveViewController.h
//  SoundCapture
//
//  Created by choe on 4/27/15.
//  Copyright (c) 2015 bong. All rights reserved.
//

#import <UIKit/UIKit.h>
// Import AVFoundation to play the file (will save EZAudioFile and EZOutput for separate example)
#import <AVFoundation/AVFoundation.h>

@interface SaveViewController : UIViewController<AVAudioPlayerDelegate>
- (IBAction)onSave:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtFilename;

@property (nonatomic) float startMarker;
@property (nonatomic) float endMarker;
@property (nonatomic, strong) NSURL *srcFile;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@end
