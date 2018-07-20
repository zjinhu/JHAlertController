//
//  ViewController.m
//  JHAlertController
//
//  Created by HU on 2018/7/19.
//  Copyright © 2018年 HU. All rights reserved.
//

#import "ViewController.h"
#import "JHAlertController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [JHAlertController showAlertWithTitle:@"111" message:@"222222222222222222222222" appearanceProcess:^(JHAlertController *alertMaker) {
            alertMaker.titleColor = [UIColor purpleColor];
            alertMaker.messageColor = [UIColor cyanColor];
            
            alertMaker.titleFont= [UIFont boldSystemFontOfSize:30];
            alertMaker.messageFont = [UIFont systemFontOfSize:5];
            
            alertMaker.addAttributedAction(@"333",[UIColor greenColor]);
            alertMaker.addDestructiveAction(@"444");
            alertMaker.addCancelAction(@"555");
            alertMaker.addDefaultAction(@"666");
            
            [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"输入框-请输入";
            }];
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction *action, JHAlertController *alertSelf) {
            NSLog(@"%i--------%@",buttonIndex,action.title);
        }];
    });

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
