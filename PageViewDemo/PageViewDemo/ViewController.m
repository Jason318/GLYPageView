//
//  ViewController.m
//  PageViewDemo
//
//  Created by Jason on 2018/11/6.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "ViewController.h"
#import "GLYPageView.h"

//  自适应宽度和高度
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

// 判断是否是iPhone X
#define IS_IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (IS_IPHONEX ? 44.f : 20.f)
// 导航栏高度
#define KNAVIVIEWHEIGHT (IS_IPHONEX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (IS_IPHONEX ? (49.f + 34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (IS_IPHONEX ? 34.f : 0.f)

@interface ViewController ()<UIScrollViewDelegate,GLYPageViewDelegate>

@property (nonatomic, assign) CGFloat      startOffsetX;
@property (nonatomic ,strong) GLYPageView  *pageView;
@property (nonatomic ,strong) UIScrollView *contentScrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.startOffsetX = 0;
    
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNAVIVIEWHEIGHT)];
    [navBar setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f]];
    [self.view addSubview:navBar];
    
    self.pageView = [[GLYPageView alloc] initWithFrame:CGRectMake(0.f, STATUS_BAR_HEIGHT, SCREEN_WIDTH, 44.f) titlesArray:@[@"最新",@"最热的帖子",@"最劲爆"]];
    self.pageView.imagesArray = @[@"NewestSelected",@"Hottest",@"Hottest"];
    self.pageView.titleFont = [UIFont systemFontOfSize:17.0];
//    self.pageView.scrollViewBackgroundColor = [UIColor orangeColor];
    self.pageView.delegate = self;
    self.pageView.imageLeft = 10.0;
    self.pageView.labelRight = 10.0;
    self.pageView.space = 10.0;
    [self.pageView initalUI];
    [self.view addSubview:self.pageView];
    
    self.contentScrollView = ({
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH , SCREEN_HEIGHT - KNAVIVIEWHEIGHT - TAB_BAR_HEIGHT)];
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3.f, 0.f);
        scrollView.backgroundColor = [UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        [self.view addSubview:scrollView];
        scrollView;
        
    });
    
    for (NSInteger i = 0; i < 5; i++)
    {
        NSInteger R = (arc4random() % 256);
        NSInteger G = (arc4random() % 256);
        NSInteger B = (arc4random() % 256);
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0.f, SCREEN_WIDTH, CGRectGetHeight(self.contentScrollView.frame))];
        colorView.backgroundColor = [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:1.f];
        [self.contentScrollView addSubview:colorView];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging || scrollView.isDecelerating)
    {
        [self.pageView externalScrollView:scrollView totalPage:3 startOffsetX:self.startOffsetX];
    }
}

#pragma mark -
#pragma mark GLYPageViewDelegate
- (void)pageViewSelectdIndex:(NSInteger)index
{
    [self.contentScrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
}


@end
