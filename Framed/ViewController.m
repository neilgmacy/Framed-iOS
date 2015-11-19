//
//  ViewController.m
//  Framed
//
//  Created by Neil McGuiggan on 31/05/2015.
//  Copyright (c) 2015 Multicoloured Software. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSArray *watchFrameNames;
    BOOL showingPicker;
}

@property (weak, nonatomic) IBOutlet UIPickerView *framePicker;
@property (weak, nonatomic) IBOutlet UIView *framedScreenshot;
@property (weak, nonatomic) IBOutlet UIButton *screenshotImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *watchFrame;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

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
        [[[UIAlertView alloc] initWithTitle:@"Uh-oh" message:@"No photo library available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = NO;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)shareScreenshot:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.framedScreenshot.bounds.size, NO, 0.0f);
    [self.framedScreenshot drawViewHierarchyInRect:self.framedScreenshot.bounds afterScreenUpdates:YES];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *pngImageData = UIImagePNGRepresentation(img);

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[pngImageData] applicationActivities:nil];
    
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
        message = @"Your screenshot couldn't be saved. Make sure Framed has permission to access your photos - you can change this in the Settings app";
    }
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (IBAction)chooseFrame:(id)sender {
    [self togglePicker];
}

- (void)togglePicker {
    self.framePicker.hidden = showingPicker;
    showingPicker = !showingPicker;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image, *editedImage, *originalImage;// = [info valueForKey:UIImagePickerControllerOriginalImage];
    editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        image = editedImage;
    } else {
        image = originalImage;
    }
    
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
    
    [self togglePicker];
}

@end
