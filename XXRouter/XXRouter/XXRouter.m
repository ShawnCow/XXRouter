//
//  XXRouter.m
//  XXRouter
//
//  Created by Shawn on 16/8/2.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "XXRouter.h"
#import "XXRouterItem.h"
#import <objc/runtime.h>


@interface UIViewController (XXRouterPrivate)

- (void)setRouterParamDic:(NSDictionary *)routerParamDic;

- (void)setRouterCallbackCompletion:(XXRouterCallbackCompletion)routerCallbackCompletion;

@end

NSString * XXRouterUrlKey = @"XXRouterUrlKey";
NSString * XXRouterFromUrlKey = @"XXRouterFromUrlKey";

@interface XXRouter ()
{
    NSMutableDictionary  * __mappingItems;
}
@end

@implementation XXRouter

- (instancetype)initWithScheme:(NSString *)scheme
{
    if (scheme.length == 0) {
        NSException * ex = [NSException exceptionWithName:@"XXRouterDomain" reason:@"scheme can not empty" userInfo:nil];
        [ex raise];
    }
    self = [super init];
    if (self) {
        _scheme = [scheme copy];
        __mappingItems = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)mappingItems
{
    NSArray * tempArray = nil;
    @synchronized (__mappingItems) {
        tempArray = [__mappingItems allValues];
    }
    return tempArray;
}

- (XXRouterItem *)itemForKey:(NSString *)key
{
    NSString * tempKey = [key copy];
    XXRouterItem * item = nil;
    @synchronized (__mappingItems) {
        item = __mappingItems[tempKey];
    }
    return item;
}

#pragma mark - register

- (void)reigsterRouterItem:(XXRouterItem *)item
{
    @synchronized (__mappingItems) {
        __mappingItems[item.key] = item;
    }
}

- (XXRouterItem *)removeRouterItemForKey:(NSString *)key
{
    XXRouterItem * item = nil;
    NSString * tempKey = [key copy];
    @synchronized (__mappingItems) {
        item = __mappingItems[tempKey];
        if (item) {
            [__mappingItems removeObjectForKey:tempKey];
        }
    }
    return item;
}

#pragma mark - 

- (BOOL)canRouterUrl:(NSURL *)url
{
    if (!url) {
        return NO;
    }
    if ([url.scheme isEqualToString:self.scheme]) {
        NSString * host = [url host];
        XXRouterItem * item = [self itemForKey:host];
        if (item) {
            return YES;
        }
    }
    return NO;
}

- (UIViewController *)routerWithUrl:(NSURL *)url
{
    return [self routerWithUrl:url completion:nil];
}

- (UIViewController *)routerWithUrl:(NSURL *)url completion:(XXRouterCallbackCompletion)completion
{
    return [self routerWithUrl:url completion:completion error:nil];
}

- (UIViewController *)routerWithUrl:(NSURL *)url completion:(XXRouterCallbackCompletion)completion error:(NSError *__autoreleasing *)error
{
    if (!url) {
        [self __routerFailedWithUrl:url errorMsg:@"router url is null" errorCode:1 error:error];
        return nil;
    }
    if ([url.scheme isEqualToString:self.scheme] == NO) {
        [self __routerFailedWithUrl:url errorMsg:@"router url scheme not support" errorCode:2 error:error];
        return nil;
    }
    NSString * key = url.host;
    XXRouterItem * item = [self itemForKey:key];
    if (!item) {
        [self __routerFailedWithUrl:url errorMsg:@"key not contain router item" errorCode:3 error:error];
        return nil;
    }
    
    BOOL shouldRouterItem = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(router:shouldRouterItem:)]) {
        shouldRouterItem = [self.delegate router:self shouldRouterItem:item];
    }
    if (shouldRouterItem == NO) {
        return nil;
    }
    
    UIViewController * rootViewController = [self rootViewController];
    if (!rootViewController) {
        [self __routerFailedWithUrl:url errorMsg:@"root viewcontroller is null, can not router" errorCode:4 error:error];
        return nil;
    }
    
    UINavigationController * nai = [self __getNavigationControllerWithRootViewController:rootViewController];
    if (nai == nil) {
        [self __routerFailedWithUrl:url errorMsg:@"not match navigation controller, can not push" errorCode:5 error:error];
        return nil;
    }
    
    NSDictionary * param = [self paramFromUrl:url];
    
    UIViewController * currentViewController = [self __getNavigationControllerWithRootViewController:rootViewController];
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    [tempDic setValue:currentViewController.routerParamDic[XXRouterUrlKey] forKey:XXRouterFromUrlKey];
    [tempDic setValue:key forKey:XXRouterUrlKey];
    if (param) {
        [tempDic addEntriesFromDictionary:param];
    }
    
    UIViewController * viewController = [item createViewController];
    [viewController setRouterParamDic:tempDic];
    [viewController setRouterCallbackCompletion:completion];
    
    [nai pushViewController:viewController animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(router:didRouterItem:viewController:)]) {
        [self.delegate router:self didRouterItem:item viewController:viewController];
    }
    return viewController;
}

- (void)__routerFailedWithUrl:(NSURL *)url errorMsg:(NSString *)errorMsg errorCode:(NSInteger)errorCode error:(NSError **)error
{
    if (error != nil) {
        if (!errorMsg) {
            errorMsg = @"Unknow error";
        }
        *error = [NSError errorWithDomain:@"XXRouterDomain" code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey]];
    }
}

- (UINavigationController *)__getNavigationControllerWithRootViewController:(UIViewController *)viewcontroller
{
    if ([viewcontroller isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)viewcontroller;
    }else if ([viewcontroller isKindOfClass:[UITabBarController class]])
    {
        return [self __getNavigationControllerWithRootViewController:[(UITabBarController *)viewcontroller selectedViewController]];
    }
    return nil;
}

- (UIViewController *)__currentVisibleViewControllerFromRootViewController:(UIViewController *)viewController
{
    if([viewController isKindOfClass:[UITabBarController class]])
    {
        return [self __currentVisibleViewControllerFromRootViewController:[(UITabBarController *)viewController selectedViewController]];
    }else if ([viewController isKindOfClass:[UINavigationController class]])
    {
        return [self __currentVisibleViewControllerFromRootViewController:[(UINavigationController *)viewController visibleViewController]];
    }
    return viewController;
}

#pragma mark - url

- (NSURL *)urlWithKey:(NSString *)key
{
    return [self urlWithKey:key param:nil];
}

- (NSURL *)urlWithKey:(NSString *)key param:(NSDictionary *)param
{
    if (!key) {
        return nil;
    }
    NSString * jsonText = nil;
    if (param) {
        NSData * data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        if (data) {
            jsonText = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    NSString * urlText = nil;
    if (jsonText) {
        urlText = [NSString stringWithFormat:@"%@://%@?body=%@",self.scheme,key,jsonText];
    }else
        urlText = [NSString stringWithFormat:@"%@://%@",self.scheme,key];
    return [NSURL URLWithString:urlText];
}

- (NSDictionary *)paramFromUrl:(NSURL *)url
{
    NSString * query = url.query;
    if (!query) {
        return nil;
    }
    NSRange range = [query rangeOfString:@"body=" options:NSCaseInsensitiveSearch];
    if (range.location == NSNotFound || range.location != 0) {
        return nil;
    }else
    {
        NSString * subText = [query substringFromIndex:range.location + range.length];
        NSString * decodeText = [subText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[decodeText dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }
}

@end

@implementation UIViewController (XXRouter)

static char * XXViewControllerRouterParamKey = "XXViewControllerRouterParamKey";
static char * XXViewControllerRouterCallbackCompletionKey   = "XXViewControllerRouterCallbackCompletionKey";

- (void)setRouterParamDic:(NSDictionary *)routerParamDic
{
    objc_setAssociatedObject(self, XXViewControllerRouterParamKey, routerParamDic, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)routerParamDic
{
    return objc_getAssociatedObject(self, XXViewControllerRouterParamKey);
}

- (void)setRouterCallbackCompletion:(XXRouterCallbackCompletion)routerCallbackCompletion
{
    objc_setAssociatedObject(self, XXViewControllerRouterCallbackCompletionKey, routerCallbackCompletion, OBJC_ASSOCIATION_COPY);
}

- (XXRouterCallbackCompletion)routerCallbackCompletion
{
    return objc_getAssociatedObject(self, XXViewControllerRouterCallbackCompletionKey);
}

@end
