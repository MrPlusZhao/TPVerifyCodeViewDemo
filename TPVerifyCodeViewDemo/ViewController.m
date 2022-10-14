//
//  ViewController.m
//  TPVerifyCodeViewDemo
//
//  Created by ztp on 2022/10/14.
//

#import "ViewController.h"
#import "TPVerifyCodeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TPVerifyCodeView *view = [[TPVerifyCodeView alloc] init];
    
    view.codeCount = 4;
    view.singleWidth = 50;
    
    view.frame = CGRectMake(100, 100, 200, 50);
    [self.view addSubview:view];
    
    __weak TPVerifyCodeView *weakView = view;
    view.codeInputCompeletBlock = ^(NSString * _Nonnull codeString) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"输入信息" message:codeString preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakView clearCode];
        }];
        
        [alertVC addAction:action];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    };
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
