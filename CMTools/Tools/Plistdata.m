//
//  SaveLocaldata.m
//  AppDesign
//
//  Created by pg on 16/12/13.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "Plistdata.h"

@implementation Plistdata

/**
 * 保存数据到plist
 */


//保存
+(BOOL)saveData:(id)data toPlist:(NSString *)fileName{
    //获取文件的完整路径
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    //写入plist里面
    @try {
        [data writeToFile:filePatch atomically:YES];
        NSLog(@"写入成功");
        return YES;
    } @catch (NSException *exception) {
        NSLog(@"写入失败，失败原因：%@",exception);
        return NO;
    }
    
}
//读取
+(id)getPlistDataFrom:(NSString *)fileName andType:(NSString *)type{
    //获取文件的完整路径
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    if ([type isEqualToString:@"array"]) {
        NSMutableArray *rootArray = [[NSMutableArray alloc]initWithContentsOfFile:filePatch];
        return rootArray;
    }else{
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
        return dataDictionary;
    }
}
//清除
+(BOOL)clearPlist:(NSString *)fileName{
    NSFileManager *fileMger = [NSFileManager defaultManager];
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    //如果文件路径存在的话
    BOOL bRet = [fileMger fileExistsAtPath:filePatch];
    if (bRet) {
        NSError *err;
        [fileMger removeItemAtPath:filePatch error:&err];
        return YES;
    }
    return NO;
}

+ (void)saveToUserDefalut:(id)obj fromKey:(NSString *)key{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    [userDefalut setObject:obj forKey:key];
}

+ (id)getFromUserDefalutKey:(NSString *)key{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}
@end
