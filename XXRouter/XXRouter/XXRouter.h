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

typedef id (^XXRouterCallbackCompletion)(NSDictionary * dic);

@class XXRouter;
@class XXRouterItem;
@class UIViewController;

@protocol XXRouterDelegate <NSObject>

@optional

- (BOOL)router:(XXRouter *)router shouldRouterItem:(XXRouterItem *)item;

- (void)router:(XXRouter *)router didRouterItem:(XXRouterItem *)item viewController:(UIViewController *)viewController;

@end

@interface XXRouter : NSObject

- (instancetype)initWithScheme:(NSString *)scheme;

@property (nonatomic, readonly, copy) NSString * scheme;

@property (nonatomic, readonly, copy) NSArray * mappingItems;

@property (nonatomic, weak) UIViewController * rootViewController;

@property (nonatomic, weak) id <XXRouterDelegate>delegate;

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
