//
//  JDCClassProperty.m
//  GreateMovies
//
//  Created by Jidong Chen on 17/03/2017.
//  Copyright © 2017 Jidong Chen. All rights reserved.
//

#import "JDCClassProperty.h"

static NSDictionary *sTypeMap;
static NSDictionary *sAllowedJSONTypes;
static NSDictionary *sAllowedPrimitiveTypes;
static NSDictionary *sTypeMappings;

#define EncodeString(_type_) [NSString stringWithUTF8String:@encode(_type_)]

@implementation JDCClassProperty

+ (void)load
{
    /*
     All standurd json objects are instances of NSString, NSNumber, NSArray, NSDictionary, or NSNull.
     */
    sAllowedJSONTypes = @{
                          @"NSString":[NSString class],
                          @"NSNumber":[NSNumber class],
                          @"NSArray":[NSArray class],
                          @"NSDictionary":[NSDictionary class],
                          @"NSNull":[NSNull class], //immutable JSON classes
                         };

    sTypeMappings = @{
                          EncodeString(char):@(JDCClassPropertyCharType),
                          EncodeString(unsigned char):@(JDCClassPropertyUIntType),
                          
                          EncodeString(int):@(JDCClassPropertyIntType),
                          EncodeString(unsigned int):@(JDCClassPropertyUIntType),
                          
                          EncodeString(short):@(JDCClassPropertyShortType),
                          EncodeString(unsigned short):@(JDCClassPropertyUShortType),
                          
                          EncodeString(long):@(JDCClassPropertyLongType),
                          EncodeString(unsigned long):@(JDCClassPropertyULongType),
                          
                          EncodeString(long long):@(JDCClassPropertyLongLongType),
                          EncodeString(unsigned long long):@(JDCClassPropertyULongLongType),
                          
                          EncodeString(float):@(JDCClassPropertyFloatType),
                          EncodeString(double):@(JDCClassPropertyDoubleType),
                          EncodeString(_Bool):@(JDCClassPropertyCppBOOL),
                     };
}

- (id)initWithProperty:(objc_property_t)property
{
    if (self = [super init]) {
        _property = property;
        const char *name = property_getName(property);
        _propertyName = [NSString stringWithUTF8String:name];
        [self _inspectProperty:property];
    }
    
    return self;
}

- (NSString *)getPropertyAttributeString:(objc_property_t)property
{
    const char *attributes = property_getAttributes(property);
    NSString *str = [NSString stringWithUTF8String:attributes];
    return str;
}

- (void)_inspectProperty:(objc_property_t)property
{
    NSString *str = [self getPropertyAttributeString:property];
    NSArray *components = [str componentsSeparatedByString:@","];
    NSString *token = components[0];
    _isReadyOnly = [components containsObject:@"R"];
    if ([token characterAtIndex:1] == '@'
        && token.length > 3
        && [token characterAtIndex:2] == '\"') {
        NSString *name = [token substringWithRange:NSMakeRange(3, token.length-4)];
        
        _propertyTypeName = name;
        
        if (sAllowedJSONTypes[name]) {
            _propertyType = JDCClassPropertyStandandJsonType;
            _isArray = [name isEqual:@"NSArray"];
        }else{
            _propertyType = JDCClassPropertyCustomType;
        }
    }else{
        
        NSString *encodeStr = [token substringWithRange:NSMakeRange(1, 1)];
        
        NSNumber *type = sTypeMappings[encodeStr];
        if (type) {
            _propertyType = [type unsignedIntegerValue];
        }else{
            _propertyType = JDCClassPropertyOtherType;
        }
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"property name:%@ type:%d",
            self.propertyName,(int)self.propertyType];
}

@end
