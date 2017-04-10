//
//  JDCCustomModel.h
//  JDCJsonExtension
//
//  Created by Jidong Chen on 10/04/2017.
//  Copyright © 2017 Jidong Chen All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JDCJsonExtension/JDCJsonExtension.h>


/*
 Example Json text:
 {
   "p_name":"jack",
   "p_text":"Hello world",
   "p_url":"https://github.com",
     "items":[
        {
         "id":1,
         "title":"test1"
        },
        {
         "id":2,
         "title":"test2"
        },
        {
         "id":3,
         "title":"test3"
        }
     ]
 }
 */


@interface JDCCustomModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *coverUrl;

@property (nonatomic,strong) NSArray *submodels;


+ (NSDictionary *)jdc_KeyPathToClassNameMapper;
+ (NSDictionary *)jdc_jsonSerializationKeyMapper;

@end
