//
//  ViewController.m
//  XXRouter
//
//  Created by Shawn on 16/8/8.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "ViewController.h"
#import "TestRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)loginBtnAction:(id)sender {
    
    NSURL * url = [[TestRouter shareRouter]urlWithKey:@"login"];
    [[TestRouter shareRouter]routerWithUrl:url];
}
@end
