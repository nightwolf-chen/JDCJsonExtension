//
//  NSObject+JDCClassProperty.h
//
//  Created by Jidong Chen on 17/03/2017.
//  Copyright © 2017 Jidong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JDCClassProperty;

@interface NSObject (JDCClassProperty)


/*
 Get all the properties of current class.
*/
+ (NSArray<JDCClassProperty *> *)jdc_classProperties;


@end
