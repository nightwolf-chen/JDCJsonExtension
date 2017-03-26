//
//  NSObject+JDCJsonSerization.m
//  GreateMovies
//
//  Created by Jidong Chen on 17/03/2017.
//  Copyright © 2017 nirvawolf. All rights reserved.
//

#import "NSObject+JDCJsonSerialization.h"
#import "NSObject+JDCClassProperty.h"
#import "JDCClassProperty.h"

@implementation NSObject (JDCJsonSerialization)

+ (NSDictionary *)jdc_jsonDeserializationKeyMapper
{
    return @{};
}

+ (NSDictionary *)jdc_jsonSerializationKeyMapper
{
    return @{};
}

+ (NSDictionary *)jdc_KeyPathToClassNameMapper
{
    return @{};
}


- (NSDictionary *)jdc_toJsonDictionary
{
    NSDictionary *keyPathToJsonKey = [[self class] jdc_jsonDeserializationKeyMapper];
    NSDictionary *keyPathToClass = [[self class] jdc_KeyPathToClassNameMapper];
    NSArray *propertis = [[self class] jdc_classProperties];
    
    
    NSMutableDictionary *result = [NSMutableDictionary new];
    for(JDCClassProperty *property in propertis){
        
        NSString *keyPath = keyPathToJsonKey[property.propertyName]?:property.propertyName;
        
        switch (property.propertyType) {
            case JDCClassPropertyStandandJsonType:{
                if (property.isArray && keyPathToClass[property.propertyName]) {
                    NSMutableArray *nArr = [NSMutableArray new];
                    NSArray *arr = [self valueForKey:property.propertyName];
                    for(NSObject *object in arr){
                        [nArr addObject:[object jdc_toJsonDictionary]];
                    }
                    [result setValue:[NSArray arrayWithArray:nArr]
                          forKeyPath:keyPath];
                }else{
                    [result setValue:[self valueForKey:property.propertyName]
                          forKeyPath:keyPath];
                }
            }
                break;
            case JDCClassPropertyCustomType:{
                [result setValue:[[self valueForKey:property.propertyName] jdc_toJsonDictionary]
                      forKeyPath:keyPath];
            }
                break;
                
            case JDCClassPropertyOtherType:{
                @throw [NSException exceptionWithName:@"unsupported json type"
                                               reason:@"NSString, NSNumber, NSArray, NSDictionary and custom Class"
                                             userInfo:nil];
            }
                break;
            default:{
                [result setValue:[self valueForKey:property.propertyName]
                      forKeyPath:keyPath];
            }
                break;
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:result];
}

- (NSString *)jdc_toJsonString:(NSError *__autoreleasing *)err
{
    NSData *data = [self jdc_toJsonData:err];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}
- (NSData *)jdc_toJsonData:(NSError *__autoreleasing *)err
{
    NSDictionary *dic = [self jdc_toJsonDictionary];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                   options:NSJSONWritingPrettyPrinted error:err];
    return data;
}

+ (NSArray *)modelsFromJsonArray:(NSArray *)jsonArray error:(NSError **)error
{
    NSMutableArray *mArr = [NSMutableArray new];
    for(NSDictionary *dic in jsonArray){
        id model = [[[self class] alloc] initWithJsonDictionary:dic error:error];
        if (error) {
            return nil;
        }
        [mArr addObject:model];
    }
    
    return [NSArray arrayWithArray:mArr];
}

+ (id)modelFromJsonObject:(NSDictionary *)jsonDictionary error:(NSError **)error
{
    return [[[self class] alloc] initWithJsonDictionary:jsonDictionary error:error];
}

- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary error:(NSError **)error
{
    self = [self init];
    
    NSDictionary *keyPathToJsonKey = [[self class] jdc_jsonSerializationKeyMapper];
    NSDictionary *keyPathToClass = [[self class] jdc_KeyPathToClassNameMapper];
    
    NSArray *propertis = [[self class] jdc_classProperties];
    for(JDCClassProperty *property in propertis){
        
        //Get json value for mapped keypath
        id value = [self getJsonValue:property.propertyName
                          jsonKeyPath:keyPathToJsonKey[property.propertyName]
                           dictionary:jsonDictionary];
        
        if (!value) {
            continue;
        }
        
        switch (property.propertyType) {
            case JDCClassPropertyStandandJsonType:{
                
                NSString *itemClassName = keyPathToClass[property.propertyName];
                if (property.isArray && itemClassName) {
                        Class itemClass = NSClassFromString(itemClassName);
                        NSArray *values = [itemClass modelsFromJsonArray:value error:error];
                    
                        if (error) {
                            return nil;
                        }
                    
                        [self setValue:values forKey:property.propertyName];
                }else{
                    [self setValue:value forKey:property.propertyName];
                }
                
            }
                
                break;
            case JDCClassPropertyCustomType:{
                Class customClass = NSClassFromString(property.propertyTypeName);
                id tValue = [[customClass alloc] initWithJsonDictionary:value error:error];
                [self setValue:tValue forKey:property.propertyName];
            }
                
                break;
                
            case JDCClassPropertyOtherType:{
                @throw [NSException exceptionWithName:@"unsupported json type"
                                               reason:@"NSString, NSNumber, NSArray, NSDictionary and custom Class"
                                             userInfo:nil];
            }
                break;
            default:{
                [self setValue:value forKey:property.propertyName];
            }
                break;
        }
    }
    
    return self;
}

- (id)getJsonValue:(NSString *)keyPath
       jsonKeyPath:(NSString *)jsonKeyPath
        dictionary:(NSDictionary *)dicionary
{
    if (jsonKeyPath) {
        return [dicionary valueForKeyPath:jsonKeyPath];
    }else{
        return [dicionary valueForKeyPath:keyPath];
    }
}

- (id)initWithJsonString:(NSString *)jsonString error:(NSError **)error
{
    return [self initWithJsonString:jsonString
                           encoding:NSUTF8StringEncoding
                              error:error];
}

- (id)initWithJsonString:(NSString *)jsonString
                encoding:(NSStringEncoding)encoding
                   error:(NSError *__autoreleasing *)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:encoding];
    return [self initWithJsonData:jsonData error:error];
}

- (id)initWithJsonData:(NSData *)jsonData error:(NSError **)error
{
    self = [self init];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:error];
    
    if ([dic isMemberOfClass:[NSDictionary class]]) {
        @throw [NSException exceptionWithName:@"Invalid json object"
                                       reason:@"Not a valid json object"
                                     userInfo:nil];
    }
    
    if (error) {
        return nil;
    }
    
    return [self initWithJsonDictionary:dic error:error];
}

@end
