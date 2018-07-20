# JHAlertController
封装系统UIAlertController，一步搞定弹窗，参考JXTAlertController封装
##API
```objc
+ (void)showAlertWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
         appearanceProcess:(JHAlertAppearanceProcess)appearanceProcess
              actionsBlock:(nullable JHAlertActionBlock)actionBlock;
```
 
```objc
+ (void)showActionSheetWithTitle:(nullable NSString *)title
                         message:(nullable NSString *)message
               appearanceProcess:(JHAlertAppearanceProcess)appearanceProcess
                    actionsBlock:(nullable JHAlertActionBlock)actionBlock;
```
## 使用方法
 
```objc
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
```
##  安装
### 1.手动添加:<br>
*   1.将 JHAlertController 文件夹添加到工程目录中<br>
*   2.导入 JHAlertController.h

### 2.CocoaPods:<br>
*   1.在 Podfile 中添加 pod 'JHAlertController'<br>
*   2.执行 pod install 或 pod update<br>
*   3.导入 JHAlertController.h



##  许可证
JHAlertController 使用 MIT 许可证，详情见 LICENSE 文件
