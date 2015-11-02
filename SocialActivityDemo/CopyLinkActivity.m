//
//  CopyLinkActivity.m
//  SocialActivityDemo
//
//  Created by 冰点 on 15/11/2.
//  Copyright © 2015年 冰点. All rights reserved.
//

#import "CopyLinkActivity.h"

@implementation CopyLinkActivity

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (NSString *)activityTitle
{
    return @"拷贝链接";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"link"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    //因为是拷贝链接，所有如果不存在NSURL对象，则返回false
    for (id item in activityItems) {
        if ([item isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)performActivity
{
    [super performActivity];
    //拷贝需要的链接
}
@end
