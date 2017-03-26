//
//  NSObject+JDCNSCoding.h
//
//  Created by Jidong Chen on 20/03/2017.
//  Copyright © 2017 Jidong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Provides default implementation for NSCoding protocoll in NSObject.
 */
@interface NSObject (JDCNSCoding)<NSCoding>

- (instancetype)initWithCoder:(NSCoder *)aDecoder;

- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
