//
//  ViewController.m
//  Screenshot Farmer
//
//  Created by Neil McGuiggan on 31/05/2015.
//  Copyright (c) 2015 Multicoloured Software. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *watchFrameNames;
}

@property (weak, nonatomic) IBOutlet UIPickerView *framePicker;
@property (weak, nonatomic) IBOutlet UIView *framedScreenshot;
@property (weak, nonatomic) IBOutlet UIButton *screenshotImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *watchFrame;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIView *transparentBackground;

@end

@implementation ViewController

typedef NS_ENUM(NSInteger, WatchFrameType) {
    WatchFrameTypeSport,
    WatchFrameTypeBlackSport,
    WatchFrameTypeSteel,
    WatchFrameTypeRoseGold,
    WatchFrameTypeYellowGold
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    watchFrameNames = @[@"Sport", @"Space Grey Sport", @"Steel", @"Rose Gold", @"Yellow Gold"];
    
    self.framePicker.delegate = self;
    self.framePicker.dataSource = self;
    [self.framePicker selectRow:2 inComponent:0 animated:YES];
}

- (IBAction)chooseScreenshot:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [[[UIAlertView alloc] initWithTitle:@"Problemo" message:@"Can't access photo library on this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    NSLog(@"Accessing photos now...");
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)shareScreenshot:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.framedScreenshot.bounds.size, self.framedScreenshot.opaque, 0.0);
    [self.framedScreenshot.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[img] applicationActivities:nil];
    
    [self presentViewController:activityViewController
                                       animated:YES
                                     completion:^{
                                         NSLog(@"Successfully shared photo."); //TODO feedback to user?
                                     }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *title = @"Success";
    NSString *message = nil;
    
    if (error) {
        title = @"Uh oh";
        message = @"Your screenshot couldn't be saved. Make sure Screenshot Farmer has permission to access your photos - you can change this in the Settings app";
    }
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (IBAction)chooseFrame:(id)sender {
    self.framePicker.hidden = NO;
    self.transparentBackground.hidden = NO;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.screenshotImageButton setImage:image forState:UIControlStateNormal];
    
    [self dismissUIImagePickerController];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissUIImagePickerController];
}

- (void)dismissUIImagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.imagePickerController = nil;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return watchFrameNames.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return watchFrameNames[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (row) {
        case WatchFrameTypeSport:
            self.watchFrame.image = [UIImage imageNamed:@"sportWatchFrame"];
            break;
        case WatchFrameTypeBlackSport:
            self.watchFrame.image = [UIImage imageNamed:@"blackSportWatchFrame"];
            break;
        case WatchFrameTypeSteel:
            self.watchFrame.image = [UIImage imageNamed:@"steelWatchFrame"];
            break;
        case WatchFrameTypeRoseGold:
            self.watchFrame.image = [UIImage imageNamed:@"roseGoldWatchFrame"];
            break;
        case WatchFrameTypeYellowGold:
            self.watchFrame.image = [UIImage imageNamed:@"yellowGoldWatchFrame"];
            break;
        default:
            break;
    }
    
    self.framePicker.hidden = YES;
    self.transparentBackground.hidden = YES;
}

@end
