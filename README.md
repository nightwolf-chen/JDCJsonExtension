# JDCJsonExtension

[![CI Status](http://img.shields.io/travis/466202783@qq.com/JDCJsonExtension.svg?style=flat)](https://travis-ci.org/nightwolf-chen/JDCJsonExtension)
[![Version](https://img.shields.io/cocoapods/v/JDCJsonExtension.svg?style=flat)](http://cocoapods.org/pods/JDCJsonExtension)
[![License](https://img.shields.io/cocoapods/l/JDCJsonExtension.svg?style=flat)](http://cocoapods.org/pods/JDCJsonExtension)
[![Platform](https://img.shields.io/cocoapods/p/JDCJsonExtension.svg?style=flat)](http://cocoapods.org/pods/JDCJsonExtension)

## Example

Let's  say you have a json text like this.
```Json
{
    "p_name":"jack",
    "p_text":"Hello world",
    "p_url":"https://github.com",
    "items":[
        {
        "id":1,
        "title":"test1"
        },
        {
        "id":2,
        "title":"test2"
        },
        {
        "id":3,
        "title":"test3"
        }
    ]
}
```
You could define models as follows.
```objective-c

@interface JDCCustomModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *coverUrl;

@property (nonatomic,strong) NSArray *submodels;


+ (NSDictionary *)jdc_KeyPathToClassNameMapper;
+ (NSDictionary *)jdc_jsonSerializationKeyMapper;

@end

@interface JDCCustomSubModel : NSObject

@property (nonatomic,strong) NSString *mid;
@property (nonatomic,strong) NSString *title;

+ (NSDictionary *)jdc_jsonSerializationKeyMapper;

@end

```

Then you just needs to add some mapping to the keys and custom class type.

```objective-c

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

@implementation JDCCustomSubModel
+ (NSDictionary *)jdc_jsonSerializationKeyMapper
{
    return @{@"mid":@"id"};
}

@end
```

Models are all set, let's initialize it with json data.

```objective-c

    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    NSError *err = nil;
    NSString *jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (!err) {
        JDCCustomModel *model = [[JDCCustomModel alloc] initWithJsonString:jsonStr error:&err];
    if (err) {
        NSLog(@"Failed !");
    }else{
        //NSCoding stuff.
        NSData *archived = [NSKeyedArchiver archivedDataWithRootObject:model];
        JDCCustomModel *unarchivedModel = [NSKeyedUnarchiver unarchiveObjectWithData:archived];
    }


```


To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JDCJsonExtension is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JDCJsonExtension"
```

## Author

Jidong Chen jidongchen93@gmail.com

## License

JDCJsonExtension is available under the MIT license. See the LICENSE file for more info.
