//
//  ViewController.m
//  MMTaskSwitcher
//
//  Created by Ralph Li on 7/22/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import "WindowsViewController.h"
#import <iCarousel/iCarousel.h>
#import "DpageViewController.h"

#define mainHeight [UIScreen mainScreen].bounds.size.height
#define mainWight [UIScreen mainScreen].bounds.size.width
@interface WindowsViewController ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, assign) CGSize cardSize;
@property (nonatomic,strong)NSMutableArray *pageControls;
@end

@implementation WindowsViewController
-(NSMutableArray *)pageControls{
    if (!_pageControls) {
        _pageControls = [NSMutableArray array];
        [_pageControls addObject:[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([DpageViewController class])]];
    }return _pageControls;
}
//+(windowsViewController*)sharedWindows{
//    static windowsViewController *window = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//      window =  [[windowsViewController alloc]init];
//    });
//    return window;
//}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setBtnText" object:nil userInfo:@{@"num":[NSString stringWithFormat:@"%ld",self.pageControls.count]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat cardWidth = [UIScreen mainScreen].bounds.size.width*5.0f/7.0f;
    self.cardSize = CGSizeMake(cardWidth, cardWidth*16.0f/9.0f);
    self.view.backgroundColor = [UIColor blackColor];
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:visualEffectView];
    self.carousel = [[iCarousel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.carousel];
    [self.carousel setScrollEnabled:YES];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = 1;
    self.carousel.scrollSpeed = 0.1f;
    self.carousel.bounceDistance = 0.2f;
    self.carousel.viewpointOffset = CGSizeMake(-cardWidth/5.0f, 0);
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, mainHeight-60,mainWight, 60)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, mainWight/2,60);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIButton *creatBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [creatBtn setTitle:@"新建" forState:UIControlStateNormal];
    [creatBtn addTarget:self action:@selector(creat) forControlEvents:UIControlEventTouchUpInside];
    creatBtn.frame = CGRectMake(mainWight/2, 0, mainWight/2,60);
    [view addSubview:creatBtn];
    [view addSubview:backBtn];
    [self.view addSubview:view];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.carousel reloadData];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self presentViewController:self.pageControls[0] animated:NO completion:nil];
    });
}
-(void)viewDidAppear:(BOOL)animated{
}
-(void)creat{
    DpageViewController *gdCtrl = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([DpageViewController class])];
    [self.pageControls addObject:gdCtrl];
    [self.carousel reloadData];
    [self.carousel scrollToItemAtIndex:self.pageControls.count-1 animated:YES];
}
-(void)back{
    if (self.pageControls.count == 0) {
        [self.pageControls addObject:[DpageViewController new]];
    }
    if (self.carousel.currentItemIndex<0) {
        [self presentViewController:self.pageControls[0] animated:YES completion:nil];
    }else{
        [self presentViewController:self.pageControls[self.carousel.currentItemIndex] animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.pageControls.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.cardSize.width;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionVisibleItems:
        {
            return 7;
        }
            
            //可以打开这里看一下效果
        case iCarouselOptionWrap:
        {
            return YES;
        }
            
        default:
            break;
    }
    
    return value;
}
-(void)delete:(UIButton *)sender{
    [self.carousel removeItemAtIndex:sender.tag animated:YES];
    [self.pageControls removeObjectAtIndex:sender.tag];
    if (self.pageControls.count == 0) {
        return;
    }
    [self.carousel reloadData];
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIViewController *gdpage = self.pageControls[index];
    UIView *myview = gdpage.view;
    UIGraphicsBeginImageContext(myview.bounds.size);
    [myview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect rect = CGRectMake(0, 0, 300/1.2, 480/1.2);
    UIImageView*imageV  = [[UIImageView alloc]initWithImage:viewImage];
    imageV.frame = rect;
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeSystem];
    [delete setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    delete.frame = CGRectMake(-10,-10,40, 40);
    delete.tag = index;
    [imageV addSubview:delete];
    imageV.userInteractionEnabled = YES;
    return imageV;
    //    UIView *cardView = view;
    //
    //    if ( !cardView )
    //    {
    //        cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cardSize.width, self.cardSize.height)];
    //        cardView.backgroundColor = [UIColor blueColor];
    //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cardView.bounds];
    //        [cardView addSubview:imageView];
    //        imageView.contentMode = UIViewContentModeScaleAspectFill;
    //        imageView.backgroundColor = [UIColor whiteColor];
    //        imageView.tag = [@"image" hash];
    //
    //        cardView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0f].CGPath;
    //        cardView.layer.shadowRadius = 3.0f;
    //        cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    //        cardView.layer.shadowOpacity = 0.5f;
    //        cardView.layer.shadowOffset = CGSizeMake(0, 0);
    //
    //        CAShapeLayer *layer = [CAShapeLayer layer];
    //        layer.frame = imageView.bounds;
    //        layer.path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:5.0f].CGPath;
    //        imageView.layer.mask = layer;
    //    }
    
    
    //    return cardView;
}


- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    CGFloat scale = [self scaleByOffset:offset];
    CGFloat translation = [self translationByOffset:offset];
    
    return CATransform3DScale(CATransform3DTranslate(transform, translation * self.cardSize.width,offset , 0), scale, scale, 1.0f);
}

- (void)carouselDidScroll:(iCarousel *)carousel
{
    for ( UIView *view in carousel.visibleItemViews)
    {
        CGFloat offset = [carousel offsetForItemAtIndex:[carousel indexOfItemView:view]];
        
        if ( offset < -3.0 )
        {
            view.alpha = 0.0f;
        }
        else if ( offset < -2.0f)
        {
            view.alpha = offset + 3.0f;
        }
        else
        {
            view.alpha = 1.0f;
        }
    }
}

//形变是线性的就ok了
- (CGFloat)scaleByOffset:(CGFloat)offset
{
    return offset*0.04f + 1.0f;
}

//位移通过得到的公式来计算
- (CGFloat)translationByOffset:(CGFloat)offset
{
    CGFloat z = 5.0f/4.0f;
    CGFloat n = 5.0f/8.0f;
    
    //z/n是临界值 >=这个值时 我们就把itemView放到比较远的地方不让他显示在屏幕上就可以了
    if ( offset >= z/n )
    {
        return 2.0f;
    }
    return 1/(z-n*offset)-1/z;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    [self presentViewController:self.pageControls[index] animated:YES completion:nil];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel{
    
};
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    
};
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    
}
- (void)carouselWillBeginDragging:(iCarousel *)carousel{
    
}
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
    
}
- (void)carouselWillBeginDecelerating:(iCarousel *)carousel{
    
}
- (void)carouselDidEndDecelerating:(iCarousel *)carousel{
    
}

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index{
    return YES;
}

//- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
//
//}
//- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
//
//}
//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
//    
//}

@end

