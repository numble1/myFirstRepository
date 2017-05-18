//
//  RightViewController.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/9.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "RightViewController.h"
#import "myCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "searchViewController.h"

@interface RightViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *commonWebsites;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,unsafe_unretained)BOOL editing;
@end

@implementation RightViewController
-(NSArray *)commonWebsites{
    if (!_commonWebsites) {
        _commonWebsites = [commonwebsiteUtil getCommonWebsite];
    }return _commonWebsites;
}
- (IBAction)cancel:(id)sender{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"myCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
        [textField endEditing:YES];
        searchViewController *searchC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
        searchC.DpageC = self.DpageC;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController: searchC];
        [self presentViewController:navi animated:NO completion:nil];
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"false",@"forward":@"false"}];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        myCollectionViewCell*cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"myCollectionViewCell" owner:self options:nil];
            cell =  cellArr[0];
        }
        UILongPressGestureRecognizer* longgs=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
        [cell addGestureRecognizer:longgs];//为cell添加手势
        longgs.minimumPressDuration=0.6;//定义长按识别时长
        longgs.view.tag=indexPath.row;//将手势和cell的序号绑定
        NSDictionary *dic = self.commonWebsites[indexPath.row];
        cell.label.text = [dic objectForKey:@"tittle"];
    if (self.editing) {
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"delete"]];
        image.frame = CGRectMake(0, 0, 20, 20);
        [cell addSubview:image];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        image.userInteractionEnabled = YES;
        image.tag = indexPath.row;
        [image addGestureRecognizer:tap];
    }
    else{
        for (UIView*vi in cell.subviews) {
            if ([vi isKindOfClass:[UIImageView class]]&&vi.userInteractionEnabled) {
                [vi removeFromSuperview];
            }
        }
    }
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/favicon.ico",[dic objectForKey:@"websiteId"]]] placeholderImage:[UIImage imageNamed:@"yushecai"]];
        NSLog(@"icon 图片%@",[NSString stringWithFormat:@"http://%@/favicon.ico",[dic objectForKey:@"websiteId"]]);
        return cell;

}
-(void)click:(UITapGestureRecognizer*)sender{
    NSInteger tag = sender.view.tag;
    NSDictionary *dic = self.commonWebsites[tag];
    [commonwebsiteUtil removeWebsite:dic];
    _commonWebsites = nil;
    self.editing = NO;
    [self.collectionView reloadData];
}
-(void)longpress:(UILongPressGestureRecognizer*)ges{
    self.editing = YES;
    [self.collectionView reloadData];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editing) {
        return;
    }
    NSDictionary *dic = self.commonWebsites[indexPath.row];
    [self.DpageC creatWebWith:dic[@"urlStr"]];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.commonWebsites.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
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

