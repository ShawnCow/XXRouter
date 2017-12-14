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

typedef void (^_XXRouterNavigationManagerCompletion)(UINavigationController * nai, UIViewController * showVc);

@interface UIViewController (XXRouterPrivate)

- (void)setRouterParamDic:(NSDictionary *)routerParamDic;

- (void)setRouterCallbackCompletion:(XXRouterCallbackCompletion)routerCallbackCompletion;

@end

NSString * XXRouterUrlKey = @"XXRouterUrlKey";
NSString * XXRouterFromUrlKey = @"XXRouterFromUrlKey";
NSString * XXRouterWebItemKey = @"web";
NSString * XXRouterLoginItemKey = @"login";

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

- (instancetype)init
{
    return [self initWithScheme:nil];
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
        if ([item.key isEqualToString:XXRouterLoginItemKey]) {
            _loginItem = item;
        }else if ([item.key isEqualToString:XXRouterWebItemKey])
        {
            _webVcItem = item;
        }
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
        if (item == _webVcItem) {
            _webVcItem = nil;
        }else if (item == _loginItem)
        {
            _loginItem = nil;
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
    }else if (([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) && self.webVcItem)
    {
        return YES;
    }
    return NO;
}

- (UIViewController *)routerWithKey:(NSString *)key
{
    return [self routerWithKey:key param:nil];
}

- (UIViewController *)routerWithKey:(NSString *)key param:(NSDictionary *)param
{
    return [self routerWithUrl:[self urlWithKey:key param:param]];
}

- (UIViewController *)routerWithUrl:(NSURL *)url
{
    return [self routerWithUrl:url completion:nil];
}

- (UIViewController *)routerWithUrl:(NSURL *)url removeVcsFromCurrentNaiStatck:(NSArray *)removeVcs
{
    return [self routerWithUrl:url removeVcsFromCurrentNaiStatck:removeVcs completion:nil];
}

- (UIViewController *)routerWithUrl:(NSURL *)url completion:(XXRouterCallbackCompletion)completion
{
    return [self routerWithUrl:url completion:completion error:nil];
}

- (UIViewController *)routerWithUrl:(NSURL *)url removeVcsFromCurrentNaiStatck:(NSArray *)removeVcs completion:(XXRouterCallbackCompletion)completion
{
    return [self routerWithUrl:url removeVcsFromCurrentNaiStatck:removeVcs completion:completion error:nil];
}

- (UIViewController *)routerWithUrl:(NSURL *)url completion:(XXRouterCallbackCompletion)completion error:(NSError *__autoreleasing *)error
{
    return [self routerWithUrl:url completion:completion navigationManagerCompletion:nil error:error];
}

- (UIViewController *)routerWithUrl:(NSURL *)url removeVcsFromCurrentNaiStatck:(NSArray *)removeVcs completion:(XXRouterCallbackCompletion)completion error:(NSError **)error
{
    return [self routerWithUrl:url completion:completion navigationManagerCompletion:^(UINavigationController *nai, UIViewController * showVc) {
        NSMutableArray * tempArray = [nai.viewControllers mutableCopy];
        [tempArray removeObjectsInArray:removeVcs];
        [tempArray addObject:showVc];
        [nai setViewControllers:tempArray animated:YES];
    } error:error];
}

- (UIViewController *)routerWithUrl:(NSURL *)url completion:(XXRouterCallbackCompletion)completion navigationManagerCompletion:(_XXRouterNavigationManagerCompletion)naiComplaetion error:(NSError *__autoreleasing *)error
{
    if (self.delegate && [self.delegate router:self url:url]) {
        url = [self.delegate router:self url:url];
    }
    
    XXRouterItem * item = nil;
    
    if (!url) {
        [self __routerFailedWithUrl:url errorMsg:@"router url is null" errorCode:1 error:error];
        return nil;
    }
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        if (self.webVcItem) {
            item = self.webVcItem;
            url = [self urlWithKey:self.webVcItem.key param:[NSDictionary dictionaryWithObject:url.absoluteString forKey:@"url"]];
        }else
        {
            [self __routerFailedWithUrl:url errorMsg:@"need regist web item, key is web" errorCode:12 error:error];
            return nil;
        }
    }else if ([url.scheme isEqualToString:self.scheme] == NO) {
        [self __routerFailedWithUrl:url errorMsg:@"router url scheme not support" errorCode:2 error:error];
        return nil;
    }
    NSString * key = url.host;
    
     item = [self itemForKey:key];
    if (!item) {
        [self __routerFailedWithUrl:url errorMsg:@"key not contain router item" errorCode:3 error:error];
        return nil;
    }
    
    if (item.needLogin && self.loginItem && self.isLogin == NO) {
        return [self routerWithUrl:[self urlWithKey:XXRouterLoginItemKey]];
    }
    
    BOOL shouldRouterItem = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(router:shouldRouterItem:)]) {
        shouldRouterItem = [self.delegate router:self shouldRouterItem:item];
    }
    if (shouldRouterItem == NO) {
        return nil;
    }
    
    NSDictionary * param = [self paramFromUrl:url];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    if (item.customHandleCompletion) {
        UIViewController * vc = nil;
        item.customHandleCompletion(self, item, param);
        if (vc) {            
            if (self.delegate && [self.delegate respondsToSelector:@selector(router:didRouterItem:viewController:)]) {
                [self.delegate router:self didRouterItem:item viewController:vc];
            }
        }
        return vc;
    }else if (item.customUICompletion)
    {
        UIViewController * vc = nil;
        item.customUICompletion(self, item);
        if (vc) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(router:didRouterItem:viewController:)]) {
                [self.delegate router:self didRouterItem:item viewController:vc];
            }
        }
        return vc;
    }
    
    UIViewController * rootViewController = [self rootViewController];
    if (!rootViewController && item.customUICompletion == nil && item.customHandleCompletion == nil) {
        [self __routerFailedWithUrl:url errorMsg:@"root viewcontroller is null, can not router" errorCode:4 error:error];
        return nil;
    }
    
    UINavigationController * nai = [self __getNavigationControllerWithRootViewController:rootViewController];
    if (nai == nil && item.customUICompletion == nil && item.customHandleCompletion == nil) {
        [self __routerFailedWithUrl:url errorMsg:@"not match navigation controller, can not push" errorCode:5 error:error];
        return nil;
    }
#pragma clang diagnostic pop
    
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
    
    if (naiComplaetion) {
        naiComplaetion(nai,viewController);
    }else
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
