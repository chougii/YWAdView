//
//  ViewController.m
//  YWAdView
//
//  Created by ChouGii on 16/2/16.
//  Copyright © 2016年 zyw. All rights reserved.
//

#import "ViewController.h"
#import "YWAdView.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YWAdView * adv = [[YWAdView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 120)];
    adv.dataDictArray = [self getdata];
    adv.PageAlignment = YWAdPagerAlignmentRight;
    adv.TextAlignment = YWAdTextAlignmentLeft;
    [self.view addSubview:adv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)getdata
{
    NSMutableArray * temp = [NSMutableArray array];
    NSMutableDictionary * dict0 = [NSMutableDictionary dictionary];
    
    [dict0 setValue:@"http://img.ivsky.com/img/tupian/pre/201511/15/baodingshan_shike.jpg" forKey:@"imgurl"];
    [dict0 setValue:@"aaaaa" forKey:@"adtext"];
    [temp addObject:dict0];
    NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:@"http://img.ivsky.com/img/tupian/pre/201511/15/baodingshan_shike-001.jpg" forKey:@"imgurl"];
    [dict1 setValue:@"bbbbb" forKey:@"adtext"];
    [temp addObject:dict1];
    NSMutableDictionary * dict2 = [NSMutableDictionary dictionary];
    [dict2 setValue:@"http://img.ivsky.com/img/tupian/pre/201511/15/baodingshan_shike-002.jpg" forKey:@"imgurl"];
    [dict2 setValue:@"ccccc" forKey:@"adtext"];
    [temp addObject:dict2];
    NSMutableDictionary * dict3 = [NSMutableDictionary dictionary];
    [dict3 setValue:@"http://img.ivsky.com/img/tupian/pre/201511/15/baodingshan_shike-003.jpg" forKey:@"imgurl"];
    [dict3 setValue:@"ddddd" forKey:@"adtext"];
    [temp addObject:dict3];
    return temp;
    
    
}


@end
