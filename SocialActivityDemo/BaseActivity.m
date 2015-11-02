//
//  BaseActivity.m
//  SocialActivityDemo
//
//  Created by 冰点 on 15/11/2.
//  Copyright © 2015年 冰点. All rights reserved.
//

#import "BaseActivity.h"


@implementation BaseActivity
@synthesize content = content_, image = image_, url = url_;

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
    //只要items有数据，就返回true。
    if (activityItems.count > 0) {
        return YES;
    }
    return NO;
}

/**
 准备数据
 
 - parameter activityItems: 数据对象数组
 */
- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSString class]]) {
            content_ = activityItem;
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
    NSLog(@"title - %@", content_);
    NSLog(@"image - %@", image_);
    NSLog(@"url - %@", url_);
}
@end
