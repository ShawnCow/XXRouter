//
//  OtherViewController.m
//  XXRouter
//
//  Created by Shawn on 2017/5/9.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "OtherViewController.h"
#import "TestRouter.h"

@interface OtherViewController ()

@end

@implementation OtherViewController

+ (void)load
{
    XXRouterItem * otherItem = [[XXRouterItem alloc]initWithClassName:NSStringFromClass(self) key:@"other"];
    otherItem.needLogin = YES;
    [[TestRouter shareRouter]reigsterRouterItem:otherItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
