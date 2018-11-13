//
//  GLYPageView.m
//  YGXXY
//
//  Created by Jason on 2018/10/31.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "GLYPageView.h"

static const NSInteger kBastTag          = 100;
static const CGFloat   kScrollViewHeight = 40.f;

static const CGFloat   kImageWidth       = 12.f;
static const CGFloat   kImageHeight      = 12.f;

@interface GLYPageView ()

/**
 scrollView离父视图上边的距离
 **/
@property (nonatomic ,assign) CGFloat      scrollViewTop;

@property (nonatomic ,strong) UIScrollView *itemScrollView;
@property (nonatomic ,strong) NSArray      *titlesArray;
@property (nonatomic ,strong) UIView       *lineView;
@property (nonatomic ,assign) BOOL         isHaveImages;

@end

@implementation GLYPageView

- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titlesArray = titlesArray;
        
        //10.f为titleLabel离父视图上边的距离，30.f为titleLabel的高度，所以设置frame的高度不得小于40.f。
        self.scrollViewTop = CGRectGetHeight(frame) - 10.f - 30.f;
        
        self.scrollViewBackgroundColor = [UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f];
        
        self.imageLeft = 18.f;
        self.labelRight = 18.f;
        
        self.selectTitleColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.f];
        self.titleColor = [UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1.f];
        self.titleFont = [UIFont systemFontOfSize:14.f];
        
        self.lineBackgroundColor = [UIColor colorWithRed:128.f/255.f green:201.f/255.f blue:205.f/255.f alpha:1.f];
        
        self.isHaveImages = NO;
    }
    
    return self;
}

- (void)initalUI
{
    CGFloat imageWidth = self.isHaveImages ? 12.f : 0.f;
    
    //所有item总长度
    CGFloat totalWidth = 0.f;

    for (NSInteger i = 0; i < self.titlesArray.count; i++)
    {
        NSString *title = self.titlesArray[i];
        CGFloat titleWidth = widthForValue(title, self.titleFont, 30.f);
        totalWidth += titleWidth + imageWidth + 2 * self.imageLeft;
    }
    
    /**
     totalWidth如果没有CGRectGetWidth(self.frame))大，则让scrollView的宽等于totalWidth，且contentsize等于totalWidth，
     相反，则让scrollView的宽等于CGRectGetWidth(self.frame))，且contentsize等于totalWidth。
     **/
    CGFloat scrollViewWidth;
    if (totalWidth < CGRectGetWidth(self.frame))
    {
        scrollViewWidth = totalWidth;
    }
    else
    {
        scrollViewWidth = CGRectGetWidth(self.frame);
    }
    
    self.itemScrollView = ({
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.scrollViewTop, scrollViewWidth, kScrollViewHeight)];
        scrollView.center = CGPointMake(CGRectGetWidth(self.frame)/2.f, scrollView.center.y);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(totalWidth, 0.f);
        scrollView.backgroundColor = self.scrollViewBackgroundColor;
        [self addSubview:scrollView];
        scrollView;
        
    });
    
    //起点位置
    CGFloat startX = 0;
    for (NSInteger i = 0; i < self.titlesArray.count; i++)
    {
        UIImageView *imageView = nil;
        if (self.isHaveImages)
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX + self.imageLeft, 19.f, kImageWidth, kImageHeight)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageNamed:self.imagesArray[i]];
            [self.itemScrollView addSubview:imageView];
        }
        
        CGFloat titleWidth = widthForValue(self.titlesArray[i], self.titleFont, 30.f);
        CGFloat left  = startX + self.imageLeft + (self.isHaveImages ? kImageWidth : 0.f);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 10.f, titleWidth, 30.f)];
        if (i == 0)
        {
            titleLabel.textColor = self.selectTitleColor;
        }
        else
        {
            titleLabel.textColor = self.titleColor;
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.userInteractionEnabled = YES;
        titleLabel.text = self.titlesArray[i];
        titleLabel.font = self.titleFont;
        titleLabel.tag = kBastTag + i;
        [self.itemScrollView addSubview:titleLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapGesture:)];
        [titleLabel addGestureRecognizer:tapGesture];
        
        startX = CGRectGetMaxX(titleLabel.frame) + self.labelRight;
        
        if (i == 0)
        {
            self.lineView = [[UIView alloc] initWithFrame:CGRectMake(self.imageLeft, kScrollViewHeight - 4.f, (self.isHaveImages ? kImageWidth : 0.f) + titleWidth, 4.f)];
            self.lineView.layer.masksToBounds = YES;
            self.lineView.layer.cornerRadius = 2.f;
            [self.lineView setBackgroundColor:self.lineBackgroundColor];
            [self.itemScrollView addSubview:self.lineView];
        }
    }
}

- (void)changeTitleColor:(UIView *)label
{
    for (NSInteger y = 0; y < self.titlesArray.count; y++)
    {
        UILabel *tempView = (UILabel *)[self.itemScrollView viewWithTag:kBastTag + y];
        if (y == label.tag - kBastTag)
        {
            tempView.textColor = self.selectTitleColor;
        }
        else
        {
            tempView.textColor = self.titleColor;
        }
    }
}

CGFloat widthForValue(NSString *value, UIFont *font, CGFloat height)
{
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return sizeToFit.size.width + 10.f;
}

- (CGRect)lineFrameWithLabel:(UIView *)label
{
    CGRect labelRect = label.frame;
    
    CGFloat titleWidth = widthForValue(self.titlesArray[label.tag - 100], self.titleFont, 30.f);
    
    CGRect lineFrame;
    if (self.isHaveImages)
    {
        lineFrame = CGRectMake(CGRectGetMinX(labelRect) - kImageWidth, CGRectGetMinY(self.lineView.frame), kImageWidth + titleWidth, 4.f);
    }
    else
    {
        lineFrame = CGRectMake(CGRectGetMinX(labelRect), CGRectGetMinY(self.lineView.frame), titleWidth, 4.f);
    }
    
    return lineFrame;
}

- (void)externalScrollView:(UIScrollView *)scrollView totalPage:(NSInteger)totalPage startOffsetX:(CGFloat)startOffsetX
{
    //滚动的百分比
    CGFloat progress = 0;
    
    //初始Index
    NSInteger sourceIndex = 0;
    
    //目标Index
    NSInteger targetIndex = 0;
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    //左滑
    if (currentOffsetX > startOffsetX)
    {
        progress = currentOffsetX / scrollViewW - floorf(currentOffsetX / scrollViewW);
        sourceIndex = (NSInteger)(currentOffsetX / scrollViewW);
        targetIndex = sourceIndex + 1;
        
        if (targetIndex >= totalPage)
        {
            targetIndex = totalPage - 1;
        }
        
        if (currentOffsetX - startOffsetX == scrollViewW)
        {
            progress = 1;
            targetIndex = sourceIndex;
            
            //目标Label
            UIView *targetLabel = [self.itemScrollView viewWithTag:kBastTag + targetIndex];
            CGFloat targetMaxX = CGRectGetMaxX(targetLabel.frame) + self.labelRight;
            
            [self changeTitleColor:targetLabel];
            
            if (targetMaxX > self.itemScrollView.contentOffset.x + self.itemScrollView.bounds.size.width)
            {
                [self.itemScrollView setContentOffset:CGPointMake(targetMaxX - self.itemScrollView.bounds.size.width, 0.f) animated:YES];
            }
        }
    }
    //右滑
    else
    {
        progress = 1 - (currentOffsetX / scrollViewW - floorf(currentOffsetX / scrollViewW));
        targetIndex = (NSInteger)(currentOffsetX / scrollViewW);
        sourceIndex = targetIndex + 1;
        
        //scrollView的页码
        if (sourceIndex >= totalPage)
        {
            sourceIndex = totalPage - 1;
        }
        
        //如果targetLabel在屏幕外面，则拉回来
        NSDecimalNumber *progressNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",progress]];
        if ([progressNumber compare:@(1)] == NSOrderedSame)
        {
            //目标Label
            UIView *targetLabel = [self.itemScrollView viewWithTag:kBastTag + targetIndex];
            CGFloat targetMinX = CGRectGetMinX(targetLabel.frame) - (self.isHaveImages ? kImageWidth : 0.f) - self.imageLeft;
            
            [self changeTitleColor:targetLabel];

            if (self.itemScrollView.contentOffset.x > targetMinX)
            {
                [self.itemScrollView setContentOffset:CGPointMake(targetMinX, 0.f) animated:YES];
            }
        }
    }
    
    [self pageViewProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}

#pragma mark -
#pragma mark 本视图上的元素受外层ScrollView的滚动影响
- (void)pageViewProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex
{
    //初始label
    UIView *sourceLabel = [self.itemScrollView viewWithTag:kBastTag + sourceIndex];
    CGRect sourceLabelRect = sourceLabel.frame;
    
    //目标Label
    UIView *targetLabel = [self.itemScrollView viewWithTag:kBastTag + targetIndex];
    CGRect targetLabelRect = targetLabel.frame;
    
    //两者间距
    CGFloat spacing = CGRectGetMinX(targetLabelRect) - CGRectGetMinX(sourceLabelRect);
    
    //两者长度差值
    CGFloat lengthDiffer = CGRectGetWidth(targetLabelRect) - CGRectGetWidth(sourceLabelRect);
    
    CGRect sourcelineFrame = [self lineFrameWithLabel:sourceLabel];
    sourcelineFrame.origin.x += spacing * progress;
    sourcelineFrame.size.width += lengthDiffer * progress;
    self.lineView.frame = sourcelineFrame;
}

#pragma mark -
#pragma mark 点击事件
- (void)itemTapGesture:(UITapGestureRecognizer *)tapGesture
{
    UIView *label = tapGesture.view;
    CGRect newLineFrame = [self lineFrameWithLabel:label];
    
    [self changeTitleColor:label];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.lineView setFrame:newLineFrame];
    }];
     
    [self.delegate pageViewSelectdIndex:label.tag - kBastTag];
}

- (void)setImagesArray:(NSArray *)imagesArray
{
    _imagesArray = imagesArray;
    _isHaveImages = YES;
}

@end
