//
//  SetViewController.m
//  yd2browser
//
//  Created by yunfenghan Ling on 5/2/17.
//  Copyright © 2017 lingyfh. All rights reserved.
//

#define FeedBackAppKey @""

#import "SetViewController.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

@interface SetViewController ()
{
    YWFeedbackKit *feedbackKit;
}
- (IBAction)feedback:(id)sender;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
- (IBAction)feedback:(id)sender {
    PLog(@"feed back");
    if ([JSONParse objIsNull:feedbackKit]) {
        feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:FeedBackAppKey];
    }
    
    /** 设置App自定义扩展反馈数据 */
    __weak typeof(self) weakSelf = self;
    [feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController != nil) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [weakSelf presentViewController:nav animated:YES completion:nil];
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            /** 使用自定义的方式抛出error时，此部分可以注释掉 */
            [self.view makeToast:@"接口调用失败，请保持网络通畅！"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
