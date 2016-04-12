//
//  ZXYWebService.m
//  Test—soap
//
//  Created by Rockeen on 16/3/24.
//  Copyright © 2016年 rockeen. All rights reserved.
//

#import "ZXYWebService.h"
#import <CommonCrypto/CommonDigest.h>
#import "XMLParser.h"

@implementation ZXYWebService


//md5加密
- (NSString *)md5Get:(NSString *)str {
    const char * cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)str.length, digest);
    NSMutableString * res = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [res appendFormat:@"%02x", digest[i]];
        
    }
    return res;
}


//有参数请求数据
+ (void)getDataParameter:(NSDictionary *)parameter WithdomStr:(NSString *)portStr WithMethod:(NSString *)method WithNfName:(NSString *)nfName
{
    
    NSString * userStr= [[NSString alloc]init];
    
    if (parameter==nil) {
        userStr=nil;
        
    }else{
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:nil];
    userStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *soapMessage=[NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n""<v:Header />\n"
                           "<v:Body>\n"
                           "<%@ xmlns=\"%@\" id=\"o0\" c:root=\"1\">\n""<sysLogin i:type=\"d:string\">%@</sysLogin>\n"
                           "</%@>\n"
                           "</v:Body>\n"
                           "</v:Envelope>\n",method,portStr,userStr,method];
    
    
    
    
    
    //创建请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:portStr]];
    
    //soap的长度
    NSString * soapMessageLenth = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    
    [request addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:soapMessageLenth forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    //将soap请求加入到请求中
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //创建连接
    
    __block NSArray *array;
    __block NSDictionary *diction;
    __block NSString *othrtSt;
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //         把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        XMLParser *xmlp=[[XMLParser alloc]initWithData:data withBlock:^(NSArray *models) {
            array=models;
        } withTowBlock:^(NSDictionary *dataDicTictionary) {
            diction=dataDicTictionary;
        } withOtherBlock:^(NSString *otherStr) {
            othrtSt=otherStr;
        }];
        
        if (array.count>=1) {
            NSLog(@"________返回的数组");
            [[NSNotificationCenter  defaultCenter]postNotificationName:nfName object:nil userInfo:@{@"data":array}];
        }
        if (diction.count>=1) {
            NSLog(@"________返回的字典");
            [[NSNotificationCenter  defaultCenter]postNotificationName:nfName object:self userInfo:@{@"data":diction}];
        }
        if (array==nil&&diction==nil) {
            NSLog(@"________返回的其他");
            [[NSNotificationCenter  defaultCenter]postNotificationName:nfName object:self userInfo:@{@"data":othrtSt}];
            
        }
        
    }];
    //启动 session
    [dataTask resume];
    
    
    
    
}


//没有参数
+ (void)getDataDomStr:(NSString *)portStr WithMethod:(NSString *)method WithNfName:(NSString *)nfName{
    
    
    
    NSString *soapMessage=[NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n""<v:Header />\n"
                           "<v:Body>\n"
                           "<%@ xmlns=\"%@\" id=\"o0\" c:root=\"1\">\n"
                           "</%@>\n"

                           "</v:Body>\n"
                           "</v:Envelope>\n",method,portStr,method];
    
    
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
//    
//    // 设置请求超时时间
//    manager.requestSerializer.timeoutInterval = 30;
//    
//    // 返回NSData
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    // 设置请求头，也可以不设置
//    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", soapMessage.length] forHTTPHeaderField:@"Content-Length"];
//    //
//    // 设置HTTPBody
//    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
//        return soapMessage;
//    }];
//    __block NSArray *array;
//    __block NSDictionary *diction;
//    __block NSString *othrtSt;
//    [manager POST:portStr parameters:soapMessage success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        // 把返回的二进制数据转为字符串
//        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        XMLParser *xmlp=[[XMLParser alloc]initWithData:responseObject withBlock:^(NSArray *models) {
//
//            array=models;
//            
//        } withTowBlock:^(NSDictionary *dataDicTictionary) {
//            diction=dataDicTictionary;
//            
//        } withOtherBlock:^(NSString *otherStr) {
//            
//            othrtSt=otherStr;
////            NSLog(@"________返回的其他%@",otherStr);
//            
//        }];
//        if (array.count>=1) {
//            NSLog(@"________返回的数组%@",array);
//
//            
//        }
//        if (diction.count>=1) {
//            NSLog(@"________返回的字典%@",diction);
//
//        }
//        if (array==nil&&diction==nil) {
//            NSLog(@"________返回的其他%@",othrtSt);
//
//        }
//        
//    }
//          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//              NSLog(@"网络请求错误————————————%@",error);
//          }];
    
    
    //创建请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:portStr]];
    
    //soap的长度
    NSString * soapMessageLenth = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    
    [request addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:soapMessageLenth forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    //将soap请求加入到请求中
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //创建连接
    
    __block NSArray *array;
    __block NSDictionary *diction;
    __block NSString *othrtSt;

    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
//         把返回的二进制数据转为字符串
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
                XMLParser *xmlp=[[XMLParser alloc]initWithData:data withBlock:^(NSArray *models) {
                    array=models;
                } withTowBlock:^(NSDictionary *dataDicTictionary) {
                    diction=dataDicTictionary;
                } withOtherBlock:^(NSString *otherStr) {
                    othrtSt=otherStr;
                }];
        
        if (array.count>=1) {
            NSLog(@"________返回的数组");
            [[NSNotificationCenter  defaultCenter]postNotificationName:nfName object:nil userInfo:@{@"data":array}];
        }
        if (diction.count>=1) {
            NSLog(@"________返回的字典");
            [[NSNotificationCenter  defaultCenter]postNotificationName:nfName object:self userInfo:@{@"data":diction}];
        }
        if (array==nil&&diction==nil) {
            NSLog(@"________返回的其他");
            [[NSNotificationCenter  defaultCenter]postNotificationName:nfName object:self userInfo:@{@"data":othrtSt}];
            
        }

    }];
    //启动 session
    [dataTask resume];
     }


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
