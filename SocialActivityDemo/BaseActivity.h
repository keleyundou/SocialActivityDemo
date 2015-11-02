//
//  BaseActivity.h
//  SocialActivityDemo
//
//  Created by 冰点 on 15/11/2.
//  Copyright © 2015年 冰点. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseActivity : UIActivity
{
    @protected
    NSString *content_;
    UIImage *image_;
    NSURL *url_;
}
@property (nonatomic, readonly, copy) NSString *content;
@property (nonatomic, readonly, strong) UIImage *image;
@property (nonatomic, readonly, copy) NSURL *url;

@end
