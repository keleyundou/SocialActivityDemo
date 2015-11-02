# 初探SocialFramework和UIActivityViewController

## UIActivityViewController

### 介绍
`UIActivityViewController`可以为应用提供分享和操作数据的系统服务接口，例如操作数据的行为有
_拷贝_、_添加到iBooks_等，
系统分享平台有_微博_、_邮箱_、_短信_ 等系统服务。

### 用法
- 基本用法

  初始化`UIActivityViewController`

```
NSString *content = @"新浪微博";
NSURL *url = [NSURL URLWithString:@"http://www.weibo.com/mgios"];
NSArray *items = @[content, url];
//初始化控件
UIActivityViewController *activeViewController =
[[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
//不显示哪些分享平台
activeViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
[self presentViewController:activeViewController animated:YES completion:nil];
//分享结果回调方法
activeViewController.completionHandler = ^(NSString *activityType, BOOL completed){
    NSLog(@"%d %@",completed,activityType);
};

// iOS8later
//    activeViewController.completionWithItemsHandler = ^(NSString * activityType, BOOL completed, NSArray * returnedItems, NSError * activityError){
//        
//    };

```

<!-- 截图 -->
<p align=center>
<img src="http://img.blog.csdn.net/20151102160558744" width=395 height=658 />
</p>



`initWithActivityItems` -- parameter 填充的是要操作的数据集合。
一般而言，分享的数据类型包括：_内容_、_图片_、_链接_

`applicationActivities` -- parameter 填充的是要分享的平台（`UIActivity`）集合。

`UIActivity`有2种分类，分别为：_`UIActivityCategoryAction`_和 _`UIActivityCategoryShare`_

#### UIActivityCategoryAction
```
UIActivityTypePrint
UIActivityTypeCopyToPasteboard
UIActivityTypeAssignToContact
UIActivityTypeSaveToCameraRoll
UIActivityTypeAddToReadingList
UIActivityTypeAirDrop
UIActivityTypeOpenInIBooks
```

#### UIActivityCategoryShare
```
UIActivityTypePostToFacebook     
UIActivityTypePostToTwitter      
UIActivityTypePostToWeibo        
UIActivityTypeMessage            
UIActivityTypeMail                           
UIActivityTypePostToFlickr       
UIActivityTypePostToVimeo        
UIActivityTypePostToTencentWeibo

```



当有一个点击行为，并分享完成后，将会回调block代码块`UIActivityViewControllerCompletionHandler`
iOS8之后此block将会被弃用，由`UIActivityViewControllerCompletionWithItemsHandler`替代

`UIActivityViewControllerCompletionHandler`回调参数

- activityType 被点击的平台类型，例如点击的平台为微博则其结果为`com.apple.UIKit.activity.PostToWeibo`
- completed 是否分享成功，NO为失败，YES为成功

`UIActivityViewControllerCompletionWithItemsHandler`回调参数

- activityType 同上
- completed 同上
- returnedItems 返回一个包含`NSExtensionItem`数组或者`nil`
- activityError 出错原因 返回`error object` 或者`nil`

具体参加含义请参考[`苹果开发文档`](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIActivityViewController_Class/index.html#//apple_ref/c/tdef/UIActivityViewControllerCompletionWithItemsHandler)

若想禁用某个平台服务可以调用`excludedActivityTypes`，用法如下：
```

activeViewController.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];

```

### 创建一个自定义的 UIActivity
然而，系统提供的服务大部分不适用与中国区的APP，例如：_`Facebook`_、_`Twitter`_。
所以就需要我们自定义一些组件。下面我们将会根据需要自定义一些UIActivity组件，后期可以据此做更好的拓展。

首先我先创建一个继承于`UIActivity`的`BaseActivity`类
在实现文件里重写父类的一些方法：

```
// override methods
+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

- (NSString *)activityType
{
    return [NSString stringWithFormat:@"com.bingdian.activity.%@",NSStringFromClass(self.classForCoder)];
}

/**
 返回是否可以执行

 - parameter activityItems: 从调用处传进来的items，可以通过这个items里面存放的类型数据来判断是否可以执行

 - returns: 返回true，则这个activity就会在controller上出现；否则，则不会出现
 */
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    //只要items有数据，就返回true
    return activityItems.count > 0;
}

/**
 准备数据

 - parameter activityItems: 数据对象数组
 */
- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSString class]]) {
            title_ = activityItem;
        } else if ([activityItem isKindOfClass:[UIImage class]]) {
            image_ = activityItem;
        } else if ([activityItem isKindOfClass:[NSURL class]]) {
            url_ = activityItem;
        }
    }
}

/**
 执行点击
 */

- (void)performActivity
{
    [super performActivity];
    NSLog(@"title - %@", title_);
    NSLog(@"image - %@", image_);
    NSLog(@"url - %@", url_);
}

```

接着，我们创建继承自抽象类`BaseActivity`的具体类`SinaActivity`。

具体类`SinaActivity`需要实现基类中的一些接口

```
- (NSString *)activityTitle
{
    return @"新浪微博";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"share_weibo"];
}

- (void)performActivity
{
    [super performActivity];
    //将需要分享的数据通过微博SDK进行定制
}

```

用法如下：

```
NSString *content = @"hello world";

UIImage *img = [UIImage imageNamed:@"share_weibo"];
NSURL *url = [NSURL URLWithString:@"http://www.weibo.com/mgios"];

NSArray *items = @[content, img, url];

SinaActivity *weibo = [[SinaActivity alloc] init];
CopyLinkActivity *copylink = [[CopyLinkActivity alloc] init];

UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:@[weibo, copylink]];
activityViewController.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact];
[self presentViewController:activityViewController animated:YES completion:nil];

activityViewController.completionHandler = ^(NSString * __nullable activityType, BOOL completed){
    NSLog(@"activityType:%@, completed:%d",activityType,completed);
};

```

下载Demo

---

参考链接：

1. [研究 UIActivityViewController](https://github.com/nixzhu/dev-blog/blob/master/2014-04-22-ui-activity-viewcontroller.md)<br/>
2. [UIActivityViewController的使用](http://www.jianshu.com/p/9de528d96466)

---
