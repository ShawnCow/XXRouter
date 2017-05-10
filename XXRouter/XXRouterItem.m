//
//  XXRouterItem.m
//  XXRouter
//
//  Created by Shawn on 16/8/2.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "XXRouterItem.h"
#import <UIKit/UIKit.h>

@implementation XXRouterItem

- (instancetype)initWithClassName:(NSString *)className nibName:(NSString *)nibName bundle:(NSBundle *)bundle key:(NSString *)key
{
    Class class = NSClassFromString(className);
    if (class == nil) {
        NSException * ex = [NSException exceptionWithName:@"XXRouterDomain" reason:@"class can not null" userInfo:nil];
        [ex raise];
    }
    if (!key) {
        NSException * ex = [NSException exceptionWithName:@"XXRouterDomain" reason:@"key can not null" userInfo:nil];
        [ex raise];
    }
    self = [super init];
    if (self) {
        _key = [key copy];
        _className = [className copy];
        if (nibName) {
            _nibName = [nibName copy];
            _createType = XXRouterCreateTypeWithXib;
        }else
        {
            _createType = XXRouterCreateTypeFromCode;
        }
        
        _bundle = bundle;
    }
    return self;
}

- (instancetype)initWithClassName:(NSString *)className key:(NSString *)key
{
    return [self initWithClassName:className nibName:nil bundle:nil key:key];
}

- (instancetype)initWithClassName:(NSString *)className nibName:(NSString *)nibName key:(NSString *)key
{
    return [self initWithClassName:className nibName:nibName bundle:nil key:key];
}

- (instancetype)initWithStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId bundle:(NSBundle *)bundle key:(NSString *)key
{
    if (!key) {
        NSException * ex = [NSException exceptionWithName:@"XXRouterDomain" reason:@"key can not null" userInfo:nil];
        [ex raise];
    }
    self = [super init];
    if (self) {
        _key = [key copy];
        _createType = XXRouterCreateTypeByStoryboard;
        _storyboardName = [storyboardName copy];
        _storyboardId = [storyboardId copy];
        _bundle = bundle;
    }
    return self;
}

- (instancetype)initWithStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId key:(NSString *)key
{
    return [self initWithStoryboardName:storyboardName storyboardId:storyboardId bundle:nil key:key];
}


- (UIViewController *)createViewController
{
    if (self.createType == XXRouterCreateTypeByStoryboard) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:self.storyboardName bundle:self.bundle];
        return [storyboard instantiateViewControllerWithIdentifier:self.storyboardId];
    }else
    {
        return [[NSClassFromString(self.className) alloc] initWithNibName:self.nibName bundle:self.bundle];
    }
    return nil;
}

@end
