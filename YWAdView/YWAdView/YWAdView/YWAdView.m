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
@property (nonatomic,weak) UIButton * leftView;
@property (nonatomic,weak) UIButton * centerView;
@property (nonatomic,weak) UIButton * rightView;
@property (nonatomic,strong) NSArray * localImageArray;
@end
@implementation YWAdView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(SELFWIDTH, 0);
        self.contentSize = CGSizeMake(SELFWIDTH * 3,100);
        NSLog(@"contentSize%@",NSStringFromCGSize(self.contentSize));
        NSLog(@"contentOffset%@",NSStringFromCGPoint(self.contentOffset));
        self.delegate = self;
    }
    return self;
}
-(NSArray *)localImageArray
{
    if (_localImageArray==nil) {
        NSMutableArray * tempArray = [NSMutableArray array];
        NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
        NSArray * localImageNames = [def objectForKey:@"YWAdCache_ImageNames"];
        for (int i = 0; i<localImageNames.count; i++) {
            NSString * imgPath = [self cachePathWithImageName:localImageNames[i]];
            [tempArray addObject:imgPath];
        }
        _localImageArray = tempArray;
    }
    return _localImageArray;
}

-(void)setDataDictArray:(NSArray *)dataDictArray
{
    _dataDictArray = dataDictArray;
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
    UIButton * btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SELFWIDTH, SELFHEIGHT)];
    btnLeft.backgroundColor = [UIColor redColor];
    [btnLeft setImage:[UIImage imageWithContentsOfFile:self.localImageArray[0]] forState:UIControlStateNormal];
    [self addSubview:btnLeft];
    UIButton * btnCenter = [[UIButton alloc] initWithFrame:CGRectMake(SELFWIDTH, 0, SELFWIDTH, SELFHEIGHT)];
    btnCenter.backgroundColor = [UIColor blueColor];
    [self addSubview:btnCenter];
    UIButton * btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SELFWIDTH*2, 0, SELFWIDTH, SELFHEIGHT)];
    btnRight.backgroundColor = [UIColor yellowColor];
    [self addSubview:btnRight];
    
    
}

/**
 *  缓存图片至本地
 */
-(void)cacheImage
{
    NSMutableArray * localImageNameArray = [NSMutableArray array];
    for (int i = 0; i<self.dataDictArray.count; i++) {
        //图片名
        NSString * imgName = [NSString stringWithFormat:@"y%@",[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
        NSDictionary * dict = self.dataDictArray[i];
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict valueForKey:@"imgurl"]]];
        //设置压缩比例
        NSData *scaleimgData = UIImageJPEGRepresentation([UIImage imageWithData:imgData], 0.5);
        //获取沙盒路径
        NSString*imagePath=[self cachePathWithImageName:imgName];
        
        // 将图片写入文件
        BOOL rst = [scaleimgData writeToFile:imagePath atomically:YES];
        //如果首次写入失败，再次尝试写入3次直至写入成功
        if (!rst) {
            for (int n= 0; n<3; n++) {
                BOOL rerestore = [imgData writeToFile:imagePath atomically:YES];
                if (rerestore) {
                    rst = YES;
                    break;
                }
            }
        }
        
        [localImageNameArray addObject:imgName];
    }
    
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def setObject:localImageNameArray forKey:@"YWAdCache_ImageNames"];
    [def synchronize];
}

-(NSString *)cachePathWithImageName:(NSString *)imageName
{
    NSArray* paths  =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString*imagePath=[path stringByAppendingString:[NSString stringWithFormat:@"/%@.jpg",imageName]];
    
    return imagePath;
}
@end
