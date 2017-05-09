//
//  WebViewController.m
//  XXRouter
//
//  Created by Shawn on 2017/5/9.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "WebViewController.h"
#import "TestRouter.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewController

+ (void)load
{
    XXRouterItem * item = [[XXRouterItem alloc]initWithClassName:NSStringFromClass(self) nibName:@"WebViewController" key:XXRouterWebItemKey];
    [[TestRouter shareRouter]reigsterRouterItem:item];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * host = self.routerParamDic[@"url"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:host]]];
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

@end
