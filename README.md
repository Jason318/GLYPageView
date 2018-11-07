# GLYPageView

最近在做一个项目，需要一个带图标的标签栏，在网上找了好多，都没有合适的，于是就自己写了一个，图标可选，可添加可不添加。

#### 带图标的

![Image text](https://github.com/Jason318/GLYPageView/blob/master/READMEIMAGES/EE53655F1A5B8DE0F21E7801B592A60F.gif)

#### 不带图标的

![Image text](https://github.com/Jason318/GLYPageView/blob/master/READMEIMAGES/8A1A06E02C6808FEC7020555C310E062.gif)

## 安装：

通过Cocoapods安装:

pod 'GLYPageView', '~> 0.0.1'

## 介绍：

使用很简单，就几个步骤。

#### 1.初始化

```
self.pageView = [[GLYPageView alloc] initWithFrame:CGRectMake(0.f, STATUS_BAR_HEIGHT, SCREEN_WIDTH, 44.f) titlesArray:@[@"哈哈",@"这一天天的",@"真是酸爽",@"的一批",@"啊"]];
self.pageView.imagesArray = @[@"NewestSelected",@"Hottest",@"Hottest",@"Hottest",@"Hottest"];
self.pageView.delegate = self;
[self.pageView initalUI];
[self.view addSubview:self.pageView];
```



