

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// Method for image sharing


#import "iOSNativeShare.h"

@implementation iOSNativeShare

+ (void) shareImage: (NSString *) path Text : (NSString *) text {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSArray *postItems = @[text, image];
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:postItems applicationActivities:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && [avc respondsToSelector:@selector(popoverPresentationController)]) {
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:avc];
        [popup presentPopoverFromRect:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT, 0, 0)
                               inView:[UIApplication sharedApplication].keyWindow.rootViewController.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    } else {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:avc animated:YES completion:nil];
    }
}

//Method for text sharing
+ (void) shareText: (NSString *) text {
    NSArray *postItems  = @[text];
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&  [avc respondsToSelector:@selector(popoverPresentationController)]) {
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:avc];
        
        [popup presentPopoverFromRect:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT, 0, 0)
                               inView:[UIApplication sharedApplication].keyWindow.rootViewController.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    } else {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:avc animated:YES completion:nil];
    }
}

@end

