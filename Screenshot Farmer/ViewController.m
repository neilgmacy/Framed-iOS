//
//  ViewController.m
//  Screenshot Farmer
//
//  Created by Neil McGuiggan on 31/05/2015.
//  Copyright (c) 2015 Multicoloured Software. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *framedScreenshot;
@property (weak, nonatomic) IBOutlet UIImageView *screenshotImage;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation ViewController

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

- (IBAction)saveScreenshot:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.framedScreenshot.bounds.size, self.framedScreenshot.opaque, 0.0);
    [self.framedScreenshot.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.screenshotImage.image = image;
    
    [self dismissUIImagePickerController];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissUIImagePickerController];
}

- (void)dismissUIImagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.imagePickerController = nil;
}

@end
