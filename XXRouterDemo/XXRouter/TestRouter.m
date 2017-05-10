//
//  TestRouter.m
//  XXRouter
//
//  Created by Shawn on 16/8/8.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "TestRouter.h"

@implementation TestRouter

+ (instancetype)shareRouter
{
    static TestRouter *router = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        router = [[TestRouter alloc]initWithScheme:@"tb"];
    });
    return router;
}

@end
