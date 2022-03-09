//
//  UIImageView+GifImgView.h
//  Game1537
//
//  Created by jim on 2021/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (GifImgView)

+ (void)createGIFWithImgView:(UIImageView *)imageView withImgName:(NSString *)imgName;

/** 解析gif文件数据的方法 block中会将解析的数据传递出来 */
- (void)getGifImageWithUrk:(NSURL *)url returnData:(void(^)(NSArray<UIImage *> * imageArray,NSArray<NSNumber *>*timeArray,CGFloat totalTime, NSArray<NSNumber *>* widths, NSArray<NSNumber *>* heights))dataBlock;

/** 为UIImageView添加一个设置gif图内容的方法： */
- (void)yh_setImage:(NSURL *)imageUrl;

/// 播放git图
/// @param gifName 名称
- (NSDictionary *)showGitImgsWithGif:(NSString *)gifName;
@end

NS_ASSUME_NONNULL_END
