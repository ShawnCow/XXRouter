//
//  XXRouterItem.h
//  XXRouter
//
//  Created by Shawn on 16/8/2.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger, XXRouterPlatformType)
//{
//    XXRouterPlatformTypeUniversal,
//    XXRouterPlatformTypePhone,
//    XXRouterPlatformTypePad,
//};

typedef NS_ENUM(NSUInteger, XXRouterCreateType)
{
    XXRouterCreateTypeFromCode,
    XXRouterCreateTypeWithXib,
    XXRouterCreateTypeByStoryboard,
};

@class XXRouter;
@class XXRouterItem;

typedef id (^XXRouterCustomUICompletion)(XXRouter * router, XXRouterItem * item);//废弃掉 XXRouterCustomHandleCompletion替换

typedef id (^XXRouterCustomHandleCompletion)(XXRouter * router, XXRouterItem * item, NSDictionary *param);

@class UIViewController;

@interface XXRouterItem : NSObject

@property (nonatomic, readonly, copy) NSString * key;

@property (nonatomic, readonly) XXRouterCreateType createType;

@property (nonatomic, readonly, copy) NSString * className;

@property (nonatomic, readonly, copy) NSString * nibName;

@property (nonatomic, readonly) NSBundle * bundle;

@property (nonatomic, readonly, copy) NSString * storyboardName;

@property (nonatomic, readonly, copy) NSString * storyboardId;

@property (nonatomic, copy) XXRouterCustomHandleCompletion customHandleCompletion;//自定义处理事件,如果实现这个就不会对 UI 进行跳转 需要自己处理跳转的 UI

@property (nonatomic) BOOL needLogin;

#pragma mark - 通过class创建对象

+ (instancetype)itemWithClass:(Class)vcClass key:(NSString *)key;

- (instancetype)initWithClassName:(NSString *)className key:(NSString *)key;

#pragma mark -  通过 xib创建对象

+ (instancetype)itemWithClass:(Class)vcClass nibName:(NSString *)nibName key:(NSString *)key;

- (instancetype)initWithClassName:(NSString *)className nibName:(NSString *)nibName key:(NSString *)key;

+ (instancetype)itemWithClass:(Class)vcClass nibName:(NSString *)nibName bundle:(NSBundle *)bundle key:(NSString *)key;

- (instancetype)initWithClassName:(NSString *)className nibName:(NSString *)nibName bundle:(NSBundle *)bundle key:(NSString *)key;

#pragma mark - 通过 storyboard创建对象

+ (instancetype)itemWithStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId key:(NSString *)key;

- (instancetype)initWithStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId key:(NSString *)key;

+ (instancetype)itemWithStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId bundle:(NSBundle *)bundle key:(NSString *)key;

- (instancetype)initWithStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId bundle:(NSBundle *)bundle key:(NSString *)key;

- (UIViewController *)createViewController;

@property (nonatomic, copy) XXRouterCustomUICompletion customUICompletion __attribute__((deprecated("已过期, 用customHandleCompletion替换")));

@end
