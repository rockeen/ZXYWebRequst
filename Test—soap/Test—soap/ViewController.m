//
//  ViewController.m
//  Test—soap
//
//  Created by Rockeen on 16/3/24.
//  Copyright © 2016年 rockeen. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "XMLParser.h"
#import "ZXYWebService.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

//请求数据
- (void)getData {
    

    NSString * username = @"admin";
    NSString * password = @"admin";
//  NSString * domStr = [[@"http://" stringByAppendingString:@"192.168.2.202:8081/qytx"] stringByAppendingString:@"/Server.php"];
//  NSString * pwdStr = [self md5Get:password];
    NSDictionary * userDic = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil];
// [ZXYWebService getData:userDic WithdomStr:domStr WithMethod:@"sysLogin"];
  
    NSString * domStr2 = [[@"http://" stringByAppendingString:@"192.168.2.202:8081"] stringByAppendingString:@"/qytx/Server.php"];
    
    NSDictionary * userDic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"4", @"id", nil];

    [ZXYWebService getDataParameter:userDic WithdomStr:domStr2 WithMethod:@"sysLogin"WithNfName:@"loginReturnId"];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(returnData:) name:@"loginReturnId" object:nil];

    [ZXYWebService getDataParameter:userDic2 WithdomStr:domStr2 WithMethod:@"getDataRolls"WithNfName:@"RollsreturnId"];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(returnTData:) name:@"RollsreturnId" object:nil];


}


- (void)returnData:(NSNotification *)noti{
 
    
    
    NSLog(@"noti.userinfor %@",noti.userInfo);


}
- (void)returnTData:(NSNotification *)noti{
    
    
    
    NSLog(@"TTTTnoti.userinfor %@",noti.userInfo);
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


    NSString * domStr3 = [[@"http://" stringByAppendingString:@"192.168.2.202:8081"] stringByAppendingString:@"/qytx/ServerSys.php"];

    [ZXYWebService getDataDomStr:domStr3 WithMethod:@"sysCusSourceList"WithNfName:@"loginReturnId"];


    NSString * domStr2 = [[@"http://" stringByAppendingString:@"192.168.2.202:8081"] stringByAppendingString:@"/qytx/Server.php"];
    [ZXYWebService getDataDomStr:domStr2 WithMethod:@"getRolls"WithNfName:@"loginReturnId"];
}


    
@end
