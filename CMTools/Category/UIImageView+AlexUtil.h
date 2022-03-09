//
//  UIImageView+AlexUtil.h
//  Game1537
//
//  Created by zhaosi on 2020/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (AlexUtil)

/**
*  根据图片url获取网络图片尺寸
*/
+ (CGSize)getImageSizeWithURL:(id)URL;
@end

NS_ASSUME_NONNULL_END
