//
//  XMLParser.m
//   XML文件的解析
//
//  Created by rockeen on 16/3/24.
//  Copyright © 2016年 rockeen. All rights reserved.
//

#import "XMLParser.h"


@implementation XMLParser
{
    NSMutableArray *_models;// 存数model的数组
    id _model;// model 对象
    

    NSString *_elementName;// 需要保存的节点名称
    NSString *_modelName;// 存储对象数据的model
    
    
    
    NSString *_elementString;//节点对应的属性值
    
}

- (id)initWithContentFile:(NSString *)fileName//需要解析的xml文件名
          withElementName:(NSString *)elementName//需要解析的对象
                  toModel:(NSString *)modelName//存储数据的model
                withBlock:(ParserArrayBlock)block
{
    if (self = [super init]) {
     
        
        _elementName = elementName;
        _modelName = modelName;
        
        _parserArrayBlock = block;
        
        
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
        
        _data=[[NSData alloc]initWithBase64EncodedString:fileName options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSData *data = _data;
        NSXMLParser *perser = [[NSXMLParser alloc] initWithData:data];
        
        perser.delegate = self;
        [perser parse];
        
    }
    
    return self;
}


- (id)initWithData:(NSData *)data withBlock:(ParserArrayBlock)block withTowBlock:(ParserDicBlock)blockTow withOtherBlock:(ParserOtherBlock)otherResult{


    if (self = [super init]) {
        

        
        _parserArrayBlock = block;
        _parserDicBlock=blockTow;
        _parserOtherBlock=otherResult;
    
        
        _data=data;
        
        NSXMLParser *perser = [[NSXMLParser alloc] initWithData:data];
        
        perser.delegate = self;
        [perser parse];
        
    }
    
    return self;





}


// 1. 开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser {

    NSLog(@"开始解析");
    
    
}

// 2. 解析到一个头节点
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName// 节点名称
  namespaceURI:(NSString *)namespaceURI// 空格
 qualifiedName:(NSString *)qName// 合格的属性名
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
//    NSLog(@"2");
    //判断解析的节点内容
    if ([elementName isEqualToString:@"return"]) {
        
    }if ([elementName isEqualToString:_elementName]){
        //获取需要解析的对象———> 初始化model对象
//        Class class = NSClassFromString(_modelName);
        
        
    }else {
    
        // 获取到具体的属性名，不需要具体操作
    }
    
}

// 3. 解析到节点中间的一个属性值
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string// 属性值
{
//    NSLog(@"______________第三部 %@",string);
    // 获取到具体的属性值
    _elementString = string;
}

// 4. 解析到一个尾节点
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName// 节点名称
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{

    if ([elementName isEqualToString:@"return"]) {
        
//        NSLog(@"%@",_elementString);
        
        
         _firstC=[_elementString substringWithRange:NSMakeRange(0, 1)];
        
//        NSLog(@"firdt-----%@",_firstC);
        
        
        //判断是字典还是数组
        if ([_firstC isEqualToString:@"{"]) {
            
            
            NSData *jsonData = [_elementString dataUsingEncoding:NSUTF8StringEncoding];
            NSError * error = nil;
            
            _dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"json解析失败:%@", error);
            }

//            NSLog(@"%@",_dataDic);

        }else if ([_firstC isEqualToString:@"["]){
        
        
            NSData *jsonData = [_elementString dataUsingEncoding:NSUTF8StringEncoding];
            NSError * error = nil;
            
             _dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"json解析失败:%@", error);
            }
            
//            NSLog(@"%@",_dataArray);

        }else{
            
            

//            NSLog(@"既不是字典也不是数组");
//            
//            
//            NSLog(@"---------而是返回%@",_elementString);
        
        }
        
        
        NSLog(@"文件解析完成");
    }if ([elementName isEqualToString:_elementName]) {
    
        // 获取需要的节点名称 ——> model数据完成存储 --> model存放到数组
//        [_models addObject:self.currentModel];
    
    }else {

//        [self.currentModel setValue:_elementString forKey:elementName];
        
    }
    
}
// 5. 结束解析
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
       _parserArrayBlock(_dataArray);
       _parserDicBlock(_dataDic);
    
    if (_dataArray==nil && _dataDic==nil) {
        _parserOtherBlock(_elementString);

    }else{
    
        _parserOtherBlock(nil);

    
    }
    
}

@end
