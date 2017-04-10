//
//  JDCCustomModel.m
//  JDCJsonExtension
//
//  Created by Jidong Chen on 10/04/2017.
//  Copyright © 2017 Jidong Chen All rights reserved.
//

#import "JDCCustomModel.h"
#import "JDCCustomSubModel.h"

@implementation JDCCustomModel

+ (NSDictionary *)jdc_jsonSerializationKeyMapper
{
    return @{
             @"name":@"p_name",
             @"text":@"p_text",
             @"coverUrl":@"p_url",
             @"submodels":@"items",
             };
}

+ (NSDictionary *)jdc_KeyPathToClassNameMapper
{
    return @{
             @"submodels":NSStringFromClass([JDCCustomSubModel class])
             };
}

@end
