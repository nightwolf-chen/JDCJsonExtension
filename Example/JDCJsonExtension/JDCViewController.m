//
//  JDCViewController.m
//  JDCJsonExtension
//
//  Created by Jidong Chen on 03/25/2017.
//  Copyright (c) 2017 Jidong Chen All rights reserved.
//

#import "JDCViewController.h"
#import "JDCCustomModel.h"

@interface JDCViewController ()

@end

@implementation JDCViewController

- (void)viewDidLoad
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    NSError *err = nil;
    NSString *jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (!err) {
        JDCCustomModel *model = [[JDCCustomModel alloc] initWithJsonString:jsonStr error:&err];
        if (err) {
            NSLog(@"Failed !");
        }else{
            
            NSData *archived = [NSKeyedArchiver archivedDataWithRootObject:model];
            JDCCustomModel *unarchivedModel = [NSKeyedUnarchiver unarchiveObjectWithData:archived];
            if ([unarchivedModel.name isEqual:model.name]) {
                NSLog(@"NSKeyedArchiver words!");
            }else{
                NSLog(@"NSKeyedArchiver failed to work!");
            }
        }
    }else{
        NSLog(@"Failed to read string from file.");
    }
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
