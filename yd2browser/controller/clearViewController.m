//
//  clearViewController.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/12.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "clearViewController.h"
#import<CoreLocation/CoreLocation.h>

@interface clearViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation clearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.editing = YES;
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"浏览历史";
            break;
        case 1:
            cell.textLabel.text = @"缓存文件";
            break;
        case 2:
            cell.textLabel.text = @"Cookies";
            break;
            case 3:
            cell.textLabel.text = @"账户密码";
            break;
        default:
            break;
    }
    return cell;
}
-(void)clearCookies{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSLog(@"111111cookName: %@",cookie);
        [storage deleteCookie:cookie];
    }
}
-(void)clearCache{
    //缓存web清除
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}
-(void)closeLocationFollow{
    CLLocationManager* location = [CLLocationManager new];
    [location stopUpdatingLocation];
}
-(void)clearSafari{
    [historyUtil removewAllHistory];
}
-(void)clearSecretAndAccount{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSLog(@"111111cookName: %@",cookie);
        [storage deleteCookie:cookie];
    }
}
- (IBAction)clear:(id)sender {
    NSArray *arr = self.tableView.indexPathsForSelectedRows;
    for (NSIndexPath *path in arr) {
        [self.tableView deselectRowAtIndexPath:path animated:YES];
        if (path.row==0) {
            [self clearSafari];
        }
        if (path.row==1) {
            [self clearCache];
        }
        if (path.row==2) {
            [self clearCookies];
        }
        if (path.row==3) {
            [self clearSecretAndAccount];
        }
    }
    [ToastUtils showHud:@"清除成功"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
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
