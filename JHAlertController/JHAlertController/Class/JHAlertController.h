//
//  JHAlertController.h
//  JHAlertController
//
//  Created by HU on 2018/7/19.
//  Copyright © 2018年 HU. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 JHAlertController 参考JXTAlertController封装
 添加TextField
 [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
 textField.placeholder = @"输入框1-请输入";
 }];
 获取
 UITextField *textField = alertSelf.textFields.firstObject;
 textField.text
 */
#define DefaultTitleTextColor              [UIColor blackColor]
#define DefaultMessageTextColor            [UIColor blackColor]
#define DefaultTitleTextFont               [UIFont boldSystemFontOfSize:14.0]
#define DefaultMessageTextFont             [UIFont systemFontOfSize:14.0]

@class JHAlertController;
/**
 JHAlertController: alertAction配置链
 */
typedef JHAlertController * _Nonnull (^JHAlertAction)(NSString *title);
typedef JHAlertController * _Nonnull (^JHAlertCustomAction)(NSString *title,UIColor *titleColor);
/**
 JHAlertController: alert构造块
 @param alertMaker JHAlertController配置对象
 */
typedef void(^JHAlertAppearanceProcess)(JHAlertController *alertMaker);

/**
 JHAlertController: alert按钮执行回调
 @param buttonIndex 按钮index(根据添加action的顺序)
 @param action      UIAlertAction对象
 @param alertSelf   本类对象
 */
typedef void (^JHAlertActionBlock)(NSInteger buttonIndex, UIAlertAction *action, JHAlertController *alertSelf);

@interface JHAlertController : UIAlertController

@property (nonatomic,strong) UIColor *titleColor; /**< 标题的颜色 */
@property (nonatomic,strong) UIColor *messageColor; /**< 信息的颜色 */

@property (nonatomic,strong) UIFont *titleFont; /**< 标题的字体 */
@property (nonatomic,strong) UIFont *messageFont; /**< 信息的字体 */

/**
 JHAlertController: 禁用alert弹出动画，默认执行系统的默认弹出动画
 */
- (void)alertAnimateDisabled;
/**
 JHAlertController: alert弹出后，可配置的回调
 */
@property (nullable, nonatomic, copy) void (^alertDidShow)(void);

/**
 JHAlertController: alert关闭后，可配置的回调
 */
@property (nullable, nonatomic, copy) void (^alertDidDismiss)(void);

/**
 JHAlertController: 设置toast模式展示时间：如果alert未添加任何按钮，将会以toast样式展示，这里设置展示时间，默认1s
 */
@property (nonatomic, assign) NSTimeInterval toastStyleDuration; //deafult alertShowDurationDefault = 1s

- (JHAlertAction)addDefaultAction;

- (JHAlertCustomAction)addAttributedAction;

- (JHAlertAction)addCancelAction;

- (JHAlertAction)addDestructiveAction;

/**
 JHAlertController: show-alert
 @param title             title
 @param message           message
 @param appearanceProcess alert配置过程
 @param actionBlock       alert点击响应回调
 */
+ (void)showAlertWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
         appearanceProcess:(JHAlertAppearanceProcess)appearanceProcess
              actionsBlock:(nullable JHAlertActionBlock)actionBlock;
/**
 JHAlertController: show-actionSheet
 @param title             title
 @param message           message
 @param appearanceProcess actionSheet配置过程
 @param actionBlock       actionSheet点击响应回调
 */
+ (void)showActionSheetWithTitle:(nullable NSString *)title
                         message:(nullable NSString *)message
               appearanceProcess:(JHAlertAppearanceProcess)appearanceProcess
                    actionsBlock:(nullable JHAlertActionBlock)actionBlock;
@end



