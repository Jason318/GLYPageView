# GLYPageView

最近在做一个项目，需要一个带图标的导航条，在网上找了好多，都没有合适的，于是就自己写了一个，图标可选，可添加可不添加。

#### 带图标的

![Image text](https://github.com/Jason318/GLYPageView/blob/master/READMEIMAGES/EE53655F1A5B8DE0F21E7801B592A60F.gif)

#### 不带图标的

![Image text](https://github.com/Jason318/GLYPageView/blob/master/READMEIMAGES/8A1A06E02C6808FEC7020555C310E062.gif)

## 导入：

#### 1.通过Cocoapods安装:

pod 'GLYPageView', '~> 0.0.1'

#### 2.直接把GLYPageView文件夹拖入项目

## 使用：

使用很简单，就3个步骤就可实现此功能。

#### 1.初始化

```
self.pageView = [[GLYPageView alloc] initWithFrame:CGRectMake(0.f, STATUS_BAR_HEIGHT, SCREEN_WIDTH, 44.f) titlesArray:@[@"最新",@"最热的帖子",@"最潮的我",@"这一天天的也真是",@"完美"]];
self.pageView.imagesArray = @[@"NewestSelected",@"Hottest",@"Hottest",@"Hottest",@"Hottest"];
self.pageView.delegate = self;
[self.pageView initalUI];
[self.view addSubview:self.pageView];
```
以下属性都可在初始化的时候根据自己的需求自定义：
##### 是否显示图片
##### 字体大小
##### 图标与字体之间的间距
##### 字体与右边界的距离
##### 字体颜色
##### 字体选择状态下的颜色
##### 小线条的颜色等

#### 2.实现外层ScrollView的2个代理方法

实现这个方法是为了记录每次拖动ScrollView的起点self.startOffsetX

```
#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startOffsetX = scrollView.contentOffset.x;
}

//totalPage外层ScrollView的总页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging || scrollView.isDecelerating)
    {
        [self.pageView externalScrollView:scrollView totalPage:5 startOffsetX:self.startOffsetX];
    }
}
```

#### 3.实现GLYPageViewDelegate

```
- (void)pageViewSelectdIndex:(NSInteger)index
{
    [self.contentScrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
}
```



