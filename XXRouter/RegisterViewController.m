//
//  RegisterViewController.m
//  XXRouter
//
//  Created by Shawn on 16/8/8.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "RegisterViewController.h"
#import "TestRouter.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

+ (void)load
{
    XXRouterItem * item = [[XXRouterItem alloc]initWithClassName:NSStringFromClass(self) nibName:nil key:@"register"];
    [[TestRouter shareRouter]reigsterRouterItem:item];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ 要注册",[[self routerParamDic]objectForKey:@"name"]];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
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
