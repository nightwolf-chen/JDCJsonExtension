//
//  NSObject+JDCNSCoding.m
//
//  Created by Jidong Chen on 20/03/2017.
//  Copyright © 2017 Jidong Chen. All rights reserved.
//

#import "NSObject+JDCNSCoding.h"
#import "JDCClassProperty.h"
#import "NSObject+JDCClassProperty.h"

@implementation NSObject (JDCNSCoding)

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init]) {
        NSArray *propertis = [[self class] jdc_classProperties];
        for(JDCClassProperty *property in propertis){
            if (property.propertyType == JDCClassPropertyOtherType) {
                @throw [NSException exceptionWithName:@"unsupported json type"
                                               reason:@"decoding failed"
                                             userInfo:nil];
            }
            id value = [aDecoder decodeObjectForKey:property.propertyName];
            [self setValue:value forKey:property.propertyName];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *propertis = [[self class] jdc_classProperties];
    for(JDCClassProperty *property in propertis){
        if (property.propertyType == JDCClassPropertyOtherType) {
            @throw [NSException exceptionWithName:@"unsupported json type"
                                           reason:@"encoding failed"
                                         userInfo:nil];
        }
        id value = [self valueForKey:property.propertyName];
        [aCoder encodeObject:value forKey:property.propertyName];
    }
}


@end
