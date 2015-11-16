//
//  ViewController.h
//  SoundCapture
//
//  Created by choe on 4/25/15.
//  Copyright (c) 2015 bong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Define.h"

#define kAudioFile @"tempaudio"

@interface HomeViewController : UIViewController <MPMediaPickerControllerDelegate, UIImagePickerControllerDelegate>
@property (assign, nonatomic) MediaType selectedMediaType;
@property (strong, nonatomic) NSString* selectedMediaURL;

- (IBAction)onMusicPick:(id)sender;

- (IBAction)onGalleryPick:(id)sender;

@end

