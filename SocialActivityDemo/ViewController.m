//
//  ViewController.m
//  SocialActivityDemo
//
//  Created by 冰点 on 15/11/2.
//  Copyright © 2015年 冰点. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import "SinaActivity.h"
#import "CopyLinkActivity.h"

@interface ViewController () <UIActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)systemSocialShareClicked:(id)sender {
    
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"系统分享方法" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"系统分享方法一",@"系统分享方法二",@"自定义分享", nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self systemSocialShareOne];
    } else if (buttonIndex == 1){
        [self systemSocialShareTwo];
    } else if (buttonIndex == 2) {
        [self customShare];
    } else {
         NSLog(@"点击了取消");
    }
}

- (void)systemSocialShareOne
{
    NSString *content = @"新浪微博";
    NSURL *url = [NSURL URLWithString:@"http://www.weibo.com/mgios"];
    NSArray *items = @[content, url];
    //初始化分享控件
    UIActivityViewController *activeViewController =
    [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    //不显示哪些分享平台(具体支持那些平台，可以查看Xcode的api)
    activeViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:activeViewController animated:YES completion:nil];
    //分享结果回调方法
//    activeViewController.completionHandler = ^(NSString *type, BOOL completed){
//        NSLog(@"%d %@",completed,type);
//    };
    activeViewController.completionWithItemsHandler = ^(NSString * activityType, BOOL completed, NSArray * returnedItems, NSError * activityError){
        NSLog(@"%d %@",completed,activityType);
    };
    
}

- (void)systemSocialShareTwo
{
    // 首先判断某个平台是否可用（如果未绑定账号则不可用）
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        NSLog(@"不可用");
        return;
    }
    
    /* *****可以分享的平台*****
     SOCIAL_EXTERN NSString *const SLServiceTypeTwitter NS_AVAILABLE(10_8, 6_0);
     SOCIAL_EXTERN NSString *const SLServiceTypeFacebook NS_AVAILABLE(10_8, 6_0);
     SOCIAL_EXTERN NSString *const SLServiceTypeSinaWeibo NS_AVAILABLE(10_8, 6_0);
     SOCIAL_EXTERN NSString *const SLServiceTypeTencentWeibo NS_AVAILABLE(10_9, 7_0);
     SOCIAL_EXTERN NSString *const SLServiceTypeLinkedIn NS_AVAILABLE(10_9, NA);
     */
    // 创建控制器，并设置ServiceType
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    // 添加要分享的图片
    [composeVC addImage:[UIImage imageNamed:@"Nameless"]];
    // 添加要分享的文字
    [composeVC setInitialText:@"share to PUTClub"];
    // 添加要分享的url
    [composeVC addURL:[NSURL URLWithString:@"http://www.putclub.com"]];
    // 弹出分享控制器
    [self presentViewController:composeVC animated:YES completion:nil];
    // 监听用户点击事件
    composeVC.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultDone) {
            NSLog(@"点击了发送");
        }
        else if (result == SLComposeViewControllerResultCancelled)
        {
            NSLog(@"点击了取消");
        }
    };
}

- (void)customShare
{
    NSString *content = @"hello world";
    
    UIImage *img = [UIImage imageNamed:@"share_weibo"];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    NSArray *items = @[content, img, url];
    
    SinaActivity *weibo = [[SinaActivity alloc] init];
    CopyLinkActivity *copylink = [[CopyLinkActivity alloc] init];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:@[weibo, copylink]];
    activityViewController.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact];
    [self presentViewController:activityViewController animated:YES completion:nil];
    

    activityViewController.completionHandler = ^(NSString * __nullable activityType, BOOL completed){
        NSLog(@"activityType:%@, completed:%d",activityType,completed);
    };
}
@end
