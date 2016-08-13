//
//  LoginViewController.m
//  XXRouter
//
//  Created by Shawn on 16/8/8.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "LoginViewController.h"
#import "TestRouter.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

+ (void)load
{
    XXRouterItem * item = [[XXRouterItem alloc]initWithClassName:NSStringFromClass(self) nibName:@"LoginViewController" key:@"login"];
    [[TestRouter shareRouter]reigsterRouterItem:item];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
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

- (IBAction)registerBtn:(id)sender {
    
    NSDictionary * dic = @{@"name":@"小胖子是贱人"};
    NSURL * url = [[TestRouter shareRouter]urlWithKey:@"register" param:dic];
    [[TestRouter shareRouter]routerWithUrl:url];
}

@end
