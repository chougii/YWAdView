# YWAdView
广告轮播器  
a、增加多线程优化  
b、自动将图片缓存到本地  
  
使用步骤  
1.添加头文件
```
#import "YWAdView.h"
```
2.初始化对象
```
YWAdView * adv = [[YWAdView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 120)];
```
3.设置图片数组属性
```
adv.dataDictArray = [self getdata];
```
4.添加到父容器
```
[self.view addSubview:adv];
```
  
数据示例  
```
-(NSArray *)getdata
{
    NSMutableArray * temp = [NSMutableArray array];
    NSMutableDictionary * dict0 = [NSMutableDictionary dictionary];
    
    [dict0 setValue:@"http://img.ivsky.com/img/tupian/pre/201511/15/baodingshan_shike.jpg" forKey:@"imgurl"];
    [temp addObject:dict0];
    NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:@"http://img.ivsky.com/img/tupian/pre/201511/15/baodingshan_shike-001.jpg" forKey:@"imgurl"];
    [temp addObject:dict1];
    NSMutableDictionary * dict2 = [NSMutableDictionary dictionary];
    [dict2 setValue:@"http://img.ivsky.com/img/tupian/pre/201511/15/baodingshan_shike-002.jpg" forKey:@"imgurl"];
    [temp addObject:dict2];
    NSMutableDictionary * dict3 = [NSMutableDictionary dictionary];
    [dict3 setValue:@"http://img.ivsky.com/img/tupian/pre/201511/15/baodingshan_shike-003.jpg" forKey:@"imgurl"];
    [temp addObject:dict3];
    return temp;
}
```
  
其他设置  
1.分页指示器位置
```
//adv.PageAlignment = YWAdPagerAlignmentCenter;(无描述文字默认)
                      YWAdPagerAlignmentLeft;
                      YWAdPagerAlignmentRight(有描述文字默认);
```
2.描述文字的位置
```
//adv.TextAlignment = YWAdTextAlignmentLeft(默认);
                      YWAdTextAlignmentCenter
                      YWAdTextAlignmentRight
```
3.清除缓存
```
+(void)clearCache;
```
