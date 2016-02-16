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
    YWAdView * adv = [[YWAdView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 100)];
    
    adv.dataDictArray = [self getdata];
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
    
    [dict0 setValue:@"http://www.sinotex.cn/pub/lot/2015129152035734.jpg" forKey:@"imgurl"];
    [temp addObject:dict0];
    NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:@"http://www.sinotex.cn/pub/lot/2015129152035734.jpg" forKey:@"imgurl"];
    [temp addObject:dict1];
    NSMutableDictionary * dict2 = [NSMutableDictionary dictionary];
    [dict2 setValue:@"http://www.sinotex.cn/pub/lot/2015129152035734.jpg" forKey:@"imgurl"];
    [temp addObject:dict2];
    return temp;
    
    
}


@end
