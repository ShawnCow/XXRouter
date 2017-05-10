//
//  LoginViewController.m
//  XXRouter
//
//  Created by Shawn on 2017/5/9.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "LoginViewController.h"
#import "TestRouter.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

+ (void)load
{
    XXRouterItem * loginItem = [[XXRouterItem alloc]initWithClassName:NSStringFromClass(self) nibName:@"LoginViewController" key:XXRouterLoginItemKey];
    loginItem.customUICompletion = ^(XXRouter *router,XXRouterItem *item) {
        
        UIViewController * vc = [router.loginItem createViewController];
        UINavigationController * nai = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.title = @"登录";
        nai.navigationBar.translucent = NO;
        [[[[[UIApplication sharedApplication]windows]firstObject]rootViewController]presentViewController:nai animated:YES completion:nil];
        return vc;
    };
    [[TestRouter shareRouter]reigsterRouterItem:loginItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [TestRouter shareRouter].login = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)cancelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
