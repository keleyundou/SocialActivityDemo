//
//  SinaActivity.m
//  SocialActivityDemo
//
//  Created by 冰点 on 15/11/2.
//  Copyright © 2015年 冰点. All rights reserved.
//

#import "SinaActivity.h"

@implementation SinaActivity

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
@end
