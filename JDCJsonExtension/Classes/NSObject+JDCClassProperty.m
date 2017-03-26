//
//  NSObject+JDCClassProperty.m
//  GreateMovies
//
//  Created by Jidong Chen on 17/03/2017.
//  Copyright © 2017 Jidong Chen. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+JDCClassProperty.h"
#import "JDCClassProperty.h"

static char kAssociatedCachePropertiesKey;

@implementation NSObject (JDCClassProperty)

+ (NSArray<JDCClassProperty *> *)jdc_classProperties
{
    NSArray *properties = [self getCacheProperties];
    if (!properties) {
        Class cls = self;
        NSMutableArray *all = [NSMutableArray new];
        while(cls != [NSObject class]){
            [all addObjectsFromArray:[self jdc_getProperties:cls]];
            cls = [cls superclass];
        }
        
        properties = all;
        [self setCachedProperties:all];
    }
    
    return properties;
}

+ (NSArray *)jdc_getProperties:(Class)class
{
    unsigned int pCount = 0;
    
    objc_property_t *properties = class_copyPropertyList(class, &pCount);
    
    NSMutableArray *pArray = [NSMutableArray new];
    for(int i = 0 ; i < pCount ; i++){
        objc_property_t property = properties[i];
        JDCClassProperty *clsProperty = [[JDCClassProperty alloc] initWithProperty:property];
        if (!clsProperty.isReadyOnly) {
            [pArray addObject:clsProperty];
        }
    }
    
    return pArray;
}

+ (NSArray *)getCacheProperties
{
    return objc_getAssociatedObject(self, &kAssociatedCachePropertiesKey);
}

+ (void)setCachedProperties:(NSArray *)properties
{
    objc_setAssociatedObject(self, &kAssociatedCachePropertiesKey,properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
