# webService请求XML数据并解析
###使用方法：

####1.调用方法 
 `[ZXYWebService getDataParameter:userDic2 WithdomStr:domStr2 WithMethod:@"getDataRolls"WithNfName:@"RollsreturnId"];`
 
####2.接受通知（通知名和上一步一样）：
    `[[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(returnTData:) name:@"RollsreturnId" object:nil];`

####3.接收数据
`- (void)returnTData:(NSNotification *)noti{
   NSLog(@"TTTTnoti.userinfor %@",noti.userInfo);
}`

###数据说明：
接收到的数据为一个字典，可以随意的做下一步处理




