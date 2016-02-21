//
//  YWAdView.m
//  YWAdView
//
//  Created by ChouGii on 16/2/16.
//  Copyright © 2016年 zyw. All rights reserved.
//

#import "YWAdView.h"
#define SELFWIDTH  self.bounds.size.width//广告的宽度
#define SELFHEIGHT  self.bounds.size.height//广告的高度
@interface YWAdView()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableDictionary * localImageDict;
@property (nonatomic,weak) UIPageControl * pageControl;
@property (nonatomic,weak) UIScrollView * scrollView;
@property (nonatomic,assign) int curPage;
@property (nonatomic,strong) NSTimer * timer;

@end
@implementation YWAdView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        UIScrollView * scrollView = [UIScrollView new];
        scrollView.frame = CGRectMake(0, 0, SELFWIDTH, SELFHEIGHT);
        scrollView.scrollEnabled = YES;
        scrollView.bounces  = NO;
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        NSLog(@"contentSize%@",NSStringFromCGSize(self.scrollView.contentSize));
        NSLog(@"contentOffset%@",NSStringFromCGPoint(self.scrollView.contentOffset));
        self.scrollView.delegate = self;
        
        UIPageControl * pg = [UIPageControl new];
        pg.bounds = CGRectMake(0, 0, 100, 20);
        pg.center = CGPointMake(SELFWIDTH/2, SELFHEIGHT-10);
        self.pageControl = pg;
        [self addSubview:pg];
        
        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerjump) userInfo:nil repeats:YES];
        self.timer = timer;
    }
    return self;
}

-(NSMutableDictionary *)localImageDict
{
    if (!_localImageDict) {
        NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
        _localImageDict =  [def objectForKey:@"YWAdCache_DictUrlLocalPath"];
        if (_localImageDict==nil) {
            _localImageDict = [NSMutableDictionary dictionary];
        }
    }
    return _localImageDict;
}


-(void)setDataDictArray:(NSArray *)dataDictArray
{
    _dataDictArray = dataDictArray;
     self.scrollView.contentSize = CGSizeMake(SELFWIDTH * self.dataDictArray.count,120);
    self.pageControl.pageIndicatorTintColor = [UIColor orangeColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.numberOfPages = dataDictArray.count;
    self.pageControl.bounds = CGRectMake(0, 0, 20*dataDictArray.count, 20);
    self.pageControl.currentPage=0;
    self.backgroundColor = [UIColor redColor];
    //多线程加载/缓存图片
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self cacheImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            //绘制界面
            [self setupViews];
        });
    });
}

-(void)setupViews
{
    for (int i = 0; i<self.dataDictArray.count; i++) {
        NSDictionary * dict = [self.dataDictArray objectAtIndex:i];
        NSString * localImagePath = [self cachePathWithImageName: [self.localImageDict objectForKey:[dict valueForKey:@"imgurl"]]];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SELFWIDTH*i,0, SELFWIDTH, SELFHEIGHT)];
        
        UIImage * img= [UIImage imageWithContentsOfFile:localImagePath];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [self.scrollView addSubview:btn];
    }
    [self.timer fire];
}

/**
 *  缓存图片至本地
 */
-(void)cacheImage
{
  
    for (int i = 0; i<self.dataDictArray.count; i++) {
        //获取图片地址
        NSDictionary * dict = self.dataDictArray[i];
        NSString * imgUrlStr = [dict valueForKey:@"imgurl"];
        NSString * imagePath = [self.localImageDict objectForKey:imgUrlStr];
        if (imagePath==nil) {
            //图片名
            NSString * imgName = [NSString stringWithFormat:@"y%@",[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
            
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]];
            //设置压缩比例
            NSData *scaleimgData = UIImageJPEGRepresentation([UIImage imageWithData:imgData], 1);
            //获取沙盒路径
            NSString*imagePath=[self cachePathWithImageName:imgName];
            
            // 将图片写入本地
            BOOL rst = [scaleimgData writeToFile:imagePath atomically:YES];
            //如果首次写入失败，再次尝试写入2次直至写入成功
            if (!rst) {
                for (int n= 0; n<2; n++) {
                    BOOL rerestore = [imgData writeToFile:imagePath atomically:YES];
                    if (rerestore) {
                        rst = YES;
                        break;
                    }
                }
            }
            [self.localImageDict setObject:imgName forKey:imgUrlStr];
        }
    }
    
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def setObject:self.localImageDict forKey:@"YWAdCache_DictUrlLocalPath"];
    [def synchronize];
}

-(NSString *)cachePathWithImageName:(NSString *)imageName
{
    NSArray* paths  =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString*imagePath=[path stringByAppendingString:[NSString stringWithFormat:@"/%@.jpg",imageName]];
    
    return imagePath;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (scrollView.contentOffset.x/SELFWIDTH)+0.5;
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
}
-(void)timerjump
{
    CGPoint contentoffset = self.scrollView.contentOffset;
    contentoffset.x +=SELFWIDTH;
    if (contentoffset.x>=SELFWIDTH*self.dataDictArray.count) {
        contentoffset.x=0;
    }
    [self.scrollView setContentOffset:contentoffset animated:YES];
    
}

-(void)setPageAlignment:(YWAdPagerAlignment)PageAlignment
{
    _PageAlignment = PageAlignment;
    switch (PageAlignment) {
        case YWAdPagerAlignmentLeft:
            self.pageControl.frame = CGRectMake(10, SELFHEIGHT-20, self.dataDictArray.count*20, 20);
            break;
        case YWAdPagerAlignmentRight:
            self.pageControl.frame = CGRectMake(SELFWIDTH-self.dataDictArray.count*20-10, SELFHEIGHT-20, self.dataDictArray.count*20, 20);
            break;
        default:
            break;
    }
}
@end
