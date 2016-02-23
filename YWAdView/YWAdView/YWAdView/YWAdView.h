//
//  YWAdView.h
//  YWAdView
//
//  Created by ChouGii on 16/2/16.
//  Copyright © 2016年 zyw. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    YWAdPagerAlignmentLeft,
    YWAdPagerAlignmentCenter,
    YWAdPagerAlignmentRight
    }YWAdPagerAlignment;

typedef enum {
    YWAdTextAlignmentLeft,
    YWAdTextAlignmentCenter,
    YWAdTextAlignmentRight
    }YWAdTextAlignment;
@interface YWAdView : UIView
/**
 *  imgid,imgurl,imgtext
 */
@property(strong,nonatomic) NSArray * dataDictArray;
@property (assign,nonatomic) YWAdPagerAlignment PageAlignment;
@property (assign,nonatomic) YWAdTextAlignment TextAlignment;
@end
