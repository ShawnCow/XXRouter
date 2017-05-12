//
//  HomeViewController.m
//  XXRouter
//
//  Created by Shawn on 2017/5/9.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "HomeViewController.h"
#import "TestRouter.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeViewController

+ (void)load
{
    XXRouterItem * homeItem = [[XXRouterItem alloc]initWithClassName:NSStringFromClass(self) nibName:@"HomeViewController" key:@"home"];
    homeItem.customUICompletion = ^(XXRouter *router,XXRouterItem *param) {
        
        UITabBarController * tbc = (UITabBarController *)[[[[UIApplication sharedApplication]windows]firstObject]rootViewController];
        NSArray * vcs = tbc.viewControllers;
        UINavigationController * nai = [vcs firstObject];
        if ([[nai.viewControllers firstObject] isKindOfClass:self]) {
            [nai popViewControllerAnimated:NO];
            tbc.selectedViewController = nai;
        }
        return [nai.viewControllers firstObject];
    };
    [[TestRouter shareRouter]reigsterRouterItem:homeItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (indexPath.row == 0 ) {
        cell.textLabel.text = @"my";
    }else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"other";
    }else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"test";
    }else
        cell.textLabel.text = @"https://www.baidu.com";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * key = cell.textLabel.text;
    if ([key hasPrefix:@"http"]) {
        [[TestRouter shareRouter]routerWithUrl:[NSURL URLWithString:key]];
    }else
        [[TestRouter shareRouter]routerWithUrl:[[TestRouter shareRouter]urlWithKey:key]];
}
@end
