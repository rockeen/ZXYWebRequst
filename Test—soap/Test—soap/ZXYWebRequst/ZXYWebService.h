//
//  ZXYWebService.h
//  Test—soap
//
//  Created by Rockeen on 16/3/24.
//  Copyright © 2016年 rockeen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZXYWebService : NSObject

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *dataArray;


//有参数
+ (void)getDataParameter:(NSDictionary *)parameter//参数 格式 （NSDictionary * userDic = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", pwdStr, @"password", nil];）
              WithdomStr:(NSString *)portStr //请求接口 （NSString * domStr = [[@"http://" stringByAppendingString:@"192.168.2.216:9800"] stringByAppendingString:@"/curl/appapi.php"];）
              WithMethod:(NSString *)method //方法名
              WithNfName:(NSString *)nfName;//通知名



//没有参数
+ (void)getDataDomStr:(NSString *)portStr //请求接口 （NSString * domStr = [[@"http://" stringByAppendingString:@"192.168.2.216:9800"] stringByAppendingString:@"/curl/appapi.php"];）
           WithMethod:(NSString *)method//方法名
           WithNfName:(NSString *)nfName;//通知名
@end
