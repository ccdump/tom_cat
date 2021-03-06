//
//  ViewController.m
//  TOMCat
//
//  Created by 张伟伟 on 2017/12/30.
//  Copyright © 2017年 张伟伟. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *catImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//这是一个写程序的思路，当这个方法写完，写下一个按钮事件的时候，会发现所用到的方法大多是一样的，所以应该考虑将相同的部分放到一个函数方法里
- (IBAction)drinkClick:(id)sender {
    
    //判断是否在动画，防止连续点击
    if (self.catImageView.isAnimating) {
        return;
    }
    
    NSMutableArray *picArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 81 ; i++) {
        NSString *picName = @"cat_drink";
        NSString *file = [NSString stringWithFormat:@"%@%04ld.jpg",picName,i];
        NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:nil];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
       //不要用[UIImage imageNamed:picStr]方法，这种方法系统会缓存这些图片，加载图片用[UIImage imageWithContentsOfFile:path]，可以优化内存。
       //UIImage *img = [UIImage imageNamed:picStr];
        [picArray addObject:img];
    }
    //设置动画图片数组
    self.catImageView.animationImages = picArray;
    //设置动画时间
    self.catImageView.animationDuration = picArray.count * 0.1;
    //设置循环次数
    self.catImageView.animationRepeatCount = 1;
    //开始动画
    [self.catImageView startAnimating];
    
    /*
     以下代码是内存优化的代码，如果程序所占内存过多，会被杀掉，所以如果在图片过多的情况下，要考虑清内存
     虽然下面代码不写，程序基本可以正常运行，但是内存会稍微高一点
     */
    //计算出动画所需要的时间
    CGFloat time = self.catImageView.animationDuration * self.catImageView.animationRepeatCount;
    //在动画结束后，把动画数组赋空
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.catImageView.animationImages = nil;
    });
    
}

/*
 每一个方法其实就是图片名称和图片数量不同，所以把相同的部分放到一起，不一样的传参数就行了
 */
-(void)loadAnimationImagesWithPicName:(NSString *)picName picCount:(NSInteger)picCount {
    
    if (self.catImageView.isAnimating) {
        return;
    }
    
    NSMutableArray *picArray = [NSMutableArray array];
    for (NSInteger i = 0; i < picCount ; i++) {
        NSString *file = [NSString stringWithFormat:@"%@%04ld.jpg",picName,i];
        NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:nil];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        [picArray addObject:img];
    }
    self.catImageView.animationImages = picArray;
    self.catImageView.animationDuration = picArray.count * 0.1;
    self.catImageView.animationRepeatCount = 1;
    [self.catImageView startAnimating];
    CGFloat time = self.catImageView.animationDuration * self.catImageView.animationRepeatCount;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.catImageView.animationImages = nil;
    });
}

//下面的点击事件代码就少很多了，这样解约时间和精力，也方便后期维护
- (IBAction)eatClick:(id)sender {
    [self loadAnimationImagesWithPicName:@"cat_eat" picCount:40];
}

//下面方法都是一样的，就不写了
- (IBAction)scratchClick:(id)sender {
}

- (IBAction)stomachClick:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
