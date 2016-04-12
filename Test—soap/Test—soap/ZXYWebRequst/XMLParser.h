//
//  XMLParser.h
//  XML文件的解析
//
//  Created by rockeen on 16/3/24.
//  Copyright © 2016年 rockeen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ParserArrayBlock)(NSArray *models);
typedef void(^ParserDicBlock)(NSDictionary *dataDicTictionary);
typedef void(^ParserOtherBlock)(NSString *otherStr);

@interface XMLParser : NSObject<NSXMLParserDelegate>
{

    ParserArrayBlock _parserArrayBlock;
    ParserDicBlock  _parserDicBlock;
    ParserOtherBlock _parserOtherBlock;
}
@property (nonatomic, strong) id currentModel;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *firstC;




- (id)initWithContentFile:(NSString *)fileName//需要解析的xml文件名
          withElementName:(NSString *)elementName//需要解析的对象
                  toModel:(NSString *)modelName
                withBlock:(ParserArrayBlock)block;


- (id)initWithData:(NSData *)data
                   withBlock:(ParserArrayBlock)block
                withTowBlock:(ParserDicBlock)blockTow
              withOtherBlock:(ParserOtherBlock)otherResult;





@end
