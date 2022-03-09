//
//  UIImageView+GifImgView.m
//  Game1537
//
//  Created by jim on 2021/5/30.
//

#import "UIImageView+GifImgView.h"

@implementation UIImageView (GifImgView)

+ (void)createGIFWithImgView:(UIImageView *)imageView withImgName:(NSString *)imgName{
    //1.找到gif文件路径
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:imgName?:@"" ofType:@"gif"];
    //2.获取gif文件数据
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:dataPath], NULL);

    //3.获取gif文件中图片的个数

    size_t count = CGImageSourceGetCount(source);

    //4.定义一个变量记录gif播放一轮的时间

    float allTime = 0;

    //5.定义一个可变数组存放所有图片

    NSMutableArray *imageArray = [[NSMutableArray alloc] init];

    //6.定义一个可变数组存放每一帧播放的时间

    NSMutableArray *timeArray = [[NSMutableArray alloc] init];

    //7.每张图片的宽度

    NSMutableArray *widthArray = [[NSMutableArray alloc] init];

    //8.每张图片的高度

    NSMutableArray *heightArray = [[NSMutableArray alloc] init];

    

    //遍历gif

    for (size_t i=0; i<count; i++) {

        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);

        [imageArray addObject:(__bridge UIImage *)(image)];

        CGImageRelease(image);

        

        //获取图片信息

        NSDictionary *info = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);

        NSLog(@"info---%@",info);

        //获取宽度

        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];

        //获取高度

        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];

        

        //

        [widthArray addObject:[NSNumber numberWithFloat:width]];

        [heightArray addObject:[NSNumber numberWithFloat:height]];

        

        //统计时间

        NSDictionary *timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];

        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];

        [timeArray addObject:[NSNumber numberWithFloat:time]];

    }

    //添加帧动画

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];

    NSMutableArray *times = [[NSMutableArray alloc] init];

    float currentTime = 0;

    //设置每一帧的时间占比

    for (int i=0; i<imageArray.count; i++) {

        [times addObject:[NSNumber numberWithFloat:currentTime/allTime]];

        currentTime +=[timeArray[i] floatValue];

    }

    [animation setKeyTimes:times];

    [animation setValues:imageArray];

    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];

    //设置循环

    animation.repeatCount = MAXFLOAT;

    //设置播放总时长

    animation.duration = allTime*MAXFLOAT;
    //Layer层添加
    [[imageView layer] addAnimation:animation forKey:@"gifAnimation"];
}

//解析gif文件数据的方法 block中会将解析的数据传递出来
-(void)getGifImageWithUrk:(NSURL *)url returnData:(void(^)(NSArray<UIImage *> * imageArray, NSArray<NSNumber *>*timeArray,CGFloat totalTime, NSArray<NSNumber *>* widths,NSArray<NSNumber *>* heights))dataBlock{
    //通过文件的url来将gif文件读取为图片数据引用
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    //获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    //定义一个变量记录gif播放一轮的时间
    float allTime=0;
    //存放所有图片
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    //存放每一帧播放的时间
    NSMutableArray * timeArray = [[NSMutableArray alloc]init];
    //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
    NSMutableArray * widthArray = [[NSMutableArray alloc]init];
    //存放每张图片的高度
    NSMutableArray * heightArray = [[NSMutableArray alloc]init];
    //遍历
    for (size_t i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        allTime+=time;
        [timeArray addObject:[NSNumber numberWithFloat:time]];
    }
    dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
}

//为UIImageView添加一个设置gif图内容的方法：
-(void)yh_setImage:(NSURL *)imageUrl{
    __weak id __self = self;
    [self getGifImageWithUrk:imageUrl returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, CGFloat totalTime, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights) {
        //添加帧动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        NSMutableArray * times = [[NSMutableArray alloc]init];
        float currentTime = 0;
        //设置每一帧的时间占比
        for (int i=0; i<imageArray.count; i++) {
            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
            currentTime+=[timeArray[i] floatValue];
        }
        [animation setKeyTimes:times];
        [animation setValues:imageArray];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        //设置循环
        animation.repeatCount= MAXFLOAT;
        //设置播放总时长
        animation.duration = totalTime;
        //Layer层添加
        [[(UIImageView *)__self layer]addAnimation:animation forKey:@"gifAnimation"];
    }];
}

- (NSDictionary *)showGitImgsWithGif:(NSString *)gifName{
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:gifName?:@"" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
    //2.将data数据转换成CGImageSource对象
    CGImageSourceRef imageSource = CGImageSourceCreateWithData(CFBridgingRetain(gifData), nil);
    size_t imageCount = CGImageSourceGetCount(imageSource);
    
    //3.遍历所有图片
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval totalDuration = 0;
    for (int i = 0; i<imageCount; i++) {
        //取出每一张图片
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        [images addObject:image];
        
        //持续时间
        NSDictionary *properties = (__bridge_transfer  NSDictionary*)CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil);
        NSDictionary *gifDict = [properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        NSNumber *frameDuration =
        [gifDict objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime];
        totalDuration += frameDuration.doubleValue;
    }
    return @{@"images":images.copy,@"totalDuration":@(totalDuration)};
}

@end
