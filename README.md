# YWAdView
广告轮播器  
a、经过多线程优化  (gcd)
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

