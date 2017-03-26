//
//  JDCClassProperty.h
//
//  Created by Jidong Chen on 17/03/2017.
//  Copyright © 2017 Jidong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger,JDCClassPropertyType){
    JDCClassPropertyCustomType = 1,
    JDCClassPropertyStandandJsonType,
    JDCClassPropertyCharType,
    JDCClassPropertyIntType,
    JDCClassPropertyShortType,
    JDCClassPropertyLongType,
    JDCClassPropertyLongLongType,
    JDCClassPropertyUCharType,
    JDCClassPropertyUIntType,
    JDCClassPropertyUShortType,
    JDCClassPropertyULongType,
    JDCClassPropertyULongLongType,
    JDCClassPropertyFloatType,
    JDCClassPropertyDoubleType,
    JDCClassPropertyCppBOOL,
    
    JDCClassPropertyOtherType
};

@interface JDCClassProperty : NSObject
@property (nonatomic,assign,readonly) objc_property_t property;
@property (nonatomic,assign,readonly) JDCClassPropertyType propertyType;
@property (nonatomic,copy,readonly) NSString *propertyTypeName;
@property (nonatomic,copy,readonly) NSString *propertyName;

@property (nonatomic,assign,readonly) BOOL isArray;
@property (nonatomic,assign,readonly) BOOL isReadyOnly;


- (id)initWithProperty:(objc_property_t)property;

@end
