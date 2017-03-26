//
//  NSObject+JDCJsonSerization.h
//
//  Created by Jidong Chen on 17/03/2017.
//  Copyright © 2017 Jiong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JDCJsonSerialization)

/*
 Key mapper used when create model from json.
 */
+ (NSDictionary *)jdc_jsonSerializationKeyMapper;


/*
 For array object you should set up mapping for custom class.
 
 For exampe:
 
 @perperty (nonatomic,strong) NSArray *models;
 
 If you wanna convert json array to models array to custom class JDCModel,
 you should implement this method as:
 
+ (NSDictionary *)jdc_KeyPathToClassNameMapper
 {
    return @{@"models":@"JDCModel"};
 }
 
 You should map all the custom class name for keypath which is NSArray of 
 custom objects.
 */
+ (NSDictionary *)jdc_KeyPathToClassNameMapper;


/*
 Key mapper used when convert model to json.
 */
+ (NSDictionary *)jdc_jsonDeserializationKeyMapper;


/*
 Create array of models from array of json objects(NSDictionary).
 */
+ (NSArray *)modelsFromJsonArray:(NSArray *)jsonArray
                           error:(NSError **)error;


/**
 
 Create array of models from array of json objects(NSDictionary).
 
 @param jsonDictionary Json object.
 @param error Error
 @return Return a instance of current class with values from json object.
 */
+ (id)modelFromJsonObject:(NSDictionary *)jsonDictionary
                    error:(NSError **)error;

/**
 Convert current intance values into NSDictionary according to the class structure.
 @return NSDictionary.
 */
- (NSDictionary *)jdc_toJsonDictionary;


/**
 Convert current intance values into json string according to the class structure.
 @return NSString.
 */
- (NSString *)jdc_toJsonString:(NSError **)err;

/**
 Convert current intance values into json string data according to the class structure.
 @return NSData.
 */
- (NSData *)jdc_toJsonData:(NSError **)err;


/**
 
 Init with values of json object(NSDictionary).
 
 @param jsonDictionary Json object.
 @param error Error
 @return Return a instance of current class with values from json object.
 */
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary
                       error:(NSError **)error;

/**
 
 Init with values of json object in string.
 
 @param error Error
 @return Return a instance with values from json object.
 */
- (id)initWithJsonString:(NSString *)jsonString
                   error:(NSError **)error;

/**
 
 Init with values of json object in string.
 
 @param jsonString Json in string format.
 @param encoding String encoding.
 @param error Error.
 @return Return a instance with values from json object
 */
- (id)initWithJsonString:(NSString *)jsonString
                encoding:(NSStringEncoding)encoding
                   error:(NSError **)error;

/**
 
 Init with values of json object in string.
 
 @param jsonData Json in string data format.
 @param error Error.
 @return Return a instance with values from json object
 */
- (id)initWithJsonData:(NSData *)jsonData
                 error:(NSError **)error;


@end
