//
//  TestTwoViewController.m
//  XXRouter
//
//  Created by Shawn on 2017/5/12.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "TestTwoViewController.h"
#import "TestRouter.h"

@interface TestTwoViewController ()

@end

@implementation TestTwoViewController

+ (void)load
{
    XXRouterItem * testItem = [[XXRouterItem alloc]initWithClassName:NSStringFromClass(self) nibName:@"TestTwoViewController" key:@"test"];
    [[TestRouter shareRouter]reigsterRouterItem:testItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)test:(id)sender {
    
    [[TestRouter shareRouter]routerWithUrl:[[TestRouter shareRouter]urlWithKey:@"test"] removeVcsFromCurrentNaiStatck:@[self]];
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
