//
//  UserCenterViewController.m
//  XXRouter
//
//  Created by Shawn on 2017/5/9.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "UserCenterViewController.h"
#import "TestRouter.h"

@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

+ (void)load
{
    XXRouterItem * homeItem = [[XXRouterItem alloc]initWithClassName:NSStringFromClass(self) nibName:@"UserCenterViewController" key:@"my"];
    homeItem.customHandleCompletion = ^(XXRouter *router,XXRouterItem *item, NSDictionary *param) {
        
        UITabBarController * tbc = (UITabBarController *)[[[[UIApplication sharedApplication]windows]firstObject]rootViewController];
        NSArray * vcs = tbc.viewControllers;
        UINavigationController * nai = [vcs lastObject];
        if ([[nai.viewControllers firstObject] isKindOfClass:self]) {
            [nai popViewControllerAnimated:NO];
            tbc.selectedViewController = nai;
        }
        return [nai.viewControllers lastObject];
//        return nil;
    };
    [[TestRouter shareRouter]reigsterRouterItem:homeItem];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)msgCenter:(id)sender {
    [[TestRouter shareRouter] routerWithKey:@"home" param:@{@"user":@"value"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
