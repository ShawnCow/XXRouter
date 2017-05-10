//
//  XXRouter.h
//  XXRouter
//
//  Created by Shawn on 16/8/2.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * XXRouterUrlKey;
extern NSString * XXRouterFromUrlKey;
extern NSString * XXRouterWebItemKey;       //  @"web"
extern NSString * XXRouterLoginItemKey;     //  @"login"

typedef id (^XXRouterCallbackCompletion)(NSDictionary * dic);

@class XXRouter;
@class XXRouterItem;
@class UIViewController;

@protocol XXRouterDelegate <NSObject>

@optional

- (NSURL *)router:(XXRouter *)router url:(NSURL *)url;

- (BOOL)router:(XXRouter *)router shouldRouterItem:(XXRouterItem *)item;

- (void)router:(XXRouter *)router didRouterItem:(XXRouterItem *)item viewController:(UIViewController *)viewController;

@end

@interface XXRouter : NSObject

- (instancetype)initWithScheme:(NSString *)scheme;

@property (nonatomic, readonly, copy) NSString * scheme;

@property (nonatomic, readonly, copy) NSArray * mappingItems;

@property (nonatomic, weak) UIViewController * rootViewController;

@property (nonatomic, weak) id <XXRouterDelegate>delegate;

@property (nonatomic, readonly) XXRouterItem * loginItem;//key is "login"

@property (nonatomic,getter=isLogin) BOOL login;//这个参数很不愿意添加在这里,不过将就一下 如果需要实现这个参数 请做好登录 注销的状态联动

@property (nonatomic, readonly) XXRouterItem * webVcItem;//key is "web"

- (XXRouterItem *)itemForKey:(NSString *)key;

#pragma mark - register

- (void)reigsterRouterItem:(XXRouterItem *)item;

- (XXRouterItem *)removeRouterItemForKey:(NSString *)key;

#pragma mark - router 

- (BOOL)canRouterUrl:(NSURL *)url;

- (UIViewController *)routerWithUrl:(NSURL *)url;

- (UIViewController *)routerWithUrl:(NSURL *)url completion:(XXRouterCallbackCompletion)completion;

- (UIViewController *)routerWithUrl:(NSURL *)url completion:(XXRouterCallbackCompletion)completion error:(NSError **)error;

#pragma mark - url 

- (NSURL *)urlWithKey:(NSString *)key;

- (NSURL *)urlWithKey:(NSString *)key param:(NSDictionary *)param;

- (NSDictionary *)paramFromUrl:(NSURL *)url;

@end

@interface UIViewController (XXRouter)

@property (nonatomic, copy, readonly) NSDictionary * routerParamDic;

@property (nonatomic, copy) XXRouterCallbackCompletion routerCallbackCompletion;

@end
