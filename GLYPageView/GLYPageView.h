//
//  GLYPageView.h
//  YGXXY
//
//  Created by Jason on 2018/10/31.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLYPageViewDelegate <NSObject>

- (void)pageViewSelectdIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GLYPageView : UIView

@property (nonatomic ,weak) id <GLYPageViewDelegate> delegate;

/**
 图片数组，可不传
 **/
@property (nonatomic ,strong) NSArray *imagesArray;

/**
 scrollView背景色
 **/
@property (nonatomic ,strong) UIColor *scrollViewBackgroundColor;

/**
 图片或标题居左边的距离(默认值18.f，自己可根据实际情况做修改)
 **/
@property (nonatomic ,assign) CGFloat imageLeft;

/**
 标题居左边的距离(默认值18.f，自己可根据实际情况做修改)
 **/
@property (nonatomic ,assign) CGFloat labelRight;

/**
 标题选中状态下的字体颜色(有默认值)
 **/
@property (nonatomic ,strong) UIColor *selectTitleColor;

/**
 标题未选中状态下的字体颜色(有默认值)
 **/
@property (nonatomic ,strong) UIColor *titleColor;

/**
 标题字体颜色(默认值14.f)
 **/
@property (nonatomic ,strong) UIFont  *titleFont;

/**
 lineView的背景颜色(有默认值)
 **/
@property (nonatomic ,strong) UIColor *lineBackgroundColor;

/**
 titlesArray:标题数组，不能为空
 imagesArray:图片数组，可为空
 **/
- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray;

/**
 创建子视图
 **/
- (void)initalUI;

/**
 scrollView:外部滚动视图
 totalPage:外部滚动视图总页数
 startOffsetX:每次开始拖拽的起始点位
 
 注意：需要在外部滚动视图代理scrollViewDidScroll不停调用
 **/
- (void)externalScrollView:(UIScrollView *)scrollView totalPage:(NSInteger)totalPage startOffsetX:(CGFloat)startOffsetX;

@end

NS_ASSUME_NONNULL_END
