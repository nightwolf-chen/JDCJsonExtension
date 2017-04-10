//
//  JDCCustomSubModel.m
//  JDCJsonExtension
//
//  Created by Jidong Chen on 10/04/2017.
//  Copyright © 2017 Jidong Chen All rights reserved.
//

#import "JDCCustomSubModel.h"

@implementation JDCCustomSubModel

+ (NSDictionary *)jdc_jsonSerializationKeyMapper
{
    return @{@"mid":@"id"};
}

@end
