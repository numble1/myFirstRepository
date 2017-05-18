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

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    YWFeedbackKit *feedbackKit;
}
//- (IBAction)feedback:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
      cell.textLabel.font = [UIFont systemFontOfSize:16];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"给好评";
            break;
            case 1:
            cell.textLabel.text = @"意见反馈";
            break;
        default:
            cell.textLabel.text = @"关于";
            break;
    }
    return cell;
}
#pragma mark 分割线左边距为零
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==3&&indexPath.row==0){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        return;
    }
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma mark -
//- (IBAction)feedback:(id)sender {
//    PLog(@"feed back");
//    if ([JSONParse objIsNull:feedbackKit]) {
//        feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:FeedBackAppKey];
//    }
//    
//    /** 设置App自定义扩展反馈数据 */
//    __weak typeof(self) weakSelf = self;
//    [feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
//        if (viewController != nil) {
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
//            [weakSelf presentViewController:nav animated:YES completion:nil];
//            
//            [viewController setCloseBlock:^(UIViewController *aParentController){
//                [aParentController dismissViewControllerAnimated:YES completion:nil];
//            }];
//        } else {
//            /** 使用自定义的方式抛出error时，此部分可以注释掉 */
//            [self.view makeToast:@"接口调用失败，请保持网络通畅！"];
//        }
//    }];
//}

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
