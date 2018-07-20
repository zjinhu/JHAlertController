//
//  JHAlertController.m
//  JHAlertController
//
//  Created by HU on 2018/7/19.
//  Copyright © 2018年 HU. All rights reserved.
//

#import "JHAlertController.h"
#import <objc/runtime.h>
//toast默认展示时间
static NSTimeInterval const AlertShowDurationDefault = 1.0f;

#pragma mark - I.AlertActionModel
@interface JHAlertActionModel : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) UIColor *titleColor;
@property (nonatomic, assign) UIAlertActionStyle style;
@end
@implementation JHAlertActionModel
- (instancetype)init{
    if (self = [super init]) {
        self.title = @"";
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}
@end

typedef void (^JHAlertActionsConfig)(JHAlertActionBlock actionBlock);

@interface JHAlertController ()
//JXTAlertActionModel数组
@property (nonatomic, strong) NSMutableArray <JHAlertActionModel *>* alertActionArray;
//是否操作动画
@property (nonatomic, assign) BOOL setAlertAnimated;
//action配置
- (JHAlertActionsConfig)alertActionsConfig;
@end

@implementation JHAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.alertDidDismiss) {
        self.alertDidDismiss();
    }
}
- (void)dealloc{
    //    NSLog(@"test-dealloc");
}

#pragma mark - Private
-(UIFont *)titleFont{
    return objc_getAssociatedObject(self, @selector(titleFont));
}

-(void)setTitleFont:(UIFont *)titleFont {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        //标题颜色
        if ([ivarName isEqualToString:@"_attributedTitle"] && self.title && titleFont) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.title attributes:@{NSForegroundColorAttributeName:self.titleColor?:DefaultTitleTextColor,NSFontAttributeName:titleFont}];
            [self setValue:attr forKey:@"attributedTitle"];
        }
    }
    free(ivars);
    objc_setAssociatedObject(self, @selector(titleFont), titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor *)titleColor{
    return objc_getAssociatedObject(self, @selector(titleColor));
}

-(void)setTitleColor:(UIColor *)titleColor{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        //标题颜色
        if ([ivarName isEqualToString:@"_attributedTitle"] && self.title && titleColor) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.title attributes:@{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:self.titleFont?:DefaultTitleTextFont}];
            [self setValue:attr forKey:@"attributedTitle"];
        }
    }
    free(ivars);
    objc_setAssociatedObject(self, @selector(titleColor), titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor *)messageColor{
    return objc_getAssociatedObject(self, @selector(messageColor));
}

-(void)setMessageColor:(UIColor *)messageColor{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        //描述颜色
        if ([ivarName isEqualToString:@"_attributedMessage"] && self.message && messageColor) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.message attributes:@{NSForegroundColorAttributeName:messageColor,NSFontAttributeName:self.messageFont?:DefaultMessageTextFont}];
            [self setValue:attr forKey:@"attributedMessage"];
        }
    }
    free(ivars);
    objc_setAssociatedObject(self, @selector(messageColor), messageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIFont *)messageFont{
    return objc_getAssociatedObject(self, @selector(messageFont));
}

-(void)setMessageFont:(UIFont *)messageFont{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        //描述颜色
        if ([ivarName isEqualToString:@"_attributedMessage"] && self.message && messageFont) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.message attributes:@{NSForegroundColorAttributeName:self.messageColor?:DefaultMessageTextColor,NSFontAttributeName:messageFont}];
            [self setValue:attr forKey:@"attributedMessage"];
        }
    }
    free(ivars);
    objc_setAssociatedObject(self, @selector(messageFont), messageFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//action-title数组
- (NSMutableArray<JHAlertActionModel *> *)alertActionArray{
    if (_alertActionArray == nil) {
        _alertActionArray = [NSMutableArray array];
    }
    return _alertActionArray;
}
//action配置
- (JHAlertActionsConfig)alertActionsConfig{
    return ^(JHAlertActionBlock actionBlock) {
        if (self.alertActionArray.count > 0){
            //创建action
            __weak typeof(self)weakSelf = self;
            [self.alertActionArray enumerateObjectsUsingBlock:^(JHAlertActionModel *actionModel, NSUInteger idx, BOOL * _Nonnull stop) {
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionModel.title style:actionModel.style handler:^(UIAlertAction * _Nonnull action){
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if (actionBlock) {
                        actionBlock(idx, action, strongSelf);
                    }
                }];
                if (actionModel.titleColor) {
                    [alertAction setValue:actionModel.titleColor forKey:@"titleTextColor"];
                }
                //action作为self元素，其block实现如果引用本类指针，会造成循环引用
                [self addAction:alertAction];
            }];
        }else{
            NSTimeInterval duration = self.toastStyleDuration > 0 ? self.toastStyleDuration : AlertShowDurationDefault;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:!(self.setAlertAnimated) completion:NULL];
            });
        }
    };
}

#pragma mark - Public

- (instancetype)initAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle{
    if (!(title.length > 0) && (message.length > 0) && (preferredStyle == UIAlertControllerStyleAlert)) {
        title = @"";
    }
    self = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (!self) return nil;
    
    self.setAlertAnimated = NO;
    self.toastStyleDuration = AlertShowDurationDefault;
    
    return self;
}

- (void)alertAnimateDisabled{
    self.setAlertAnimated = YES;
}

- (JHAlertAction)addDefaultAction{
    //该block返回值不是本类属性，只是局部变量，不会造成循环引用
    return ^(NSString *title) {
        JHAlertActionModel *actionModel = [[JHAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}
- (JHAlertCustomAction)addAttributedAction{
    //该block返回值不是本类属性，只是局部变量，不会造成循环引用
    return ^(NSString *title,UIColor *titleColor) {
        JHAlertActionModel *actionModel = [[JHAlertActionModel alloc] init];
        actionModel.titleColor = titleColor;
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}
- (JHAlertAction)addCancelAction{
    return ^(NSString *title) {
        JHAlertActionModel *actionModel = [[JHAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleCancel;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

- (JHAlertAction)addDestructiveAction{
    return ^(NSString *title) {
        JHAlertActionModel *actionModel = [[JHAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDestructive;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

+ (void)showAlertWithPreferredStyle:(UIAlertControllerStyle)preferredStyle title:(NSString *)title message:(NSString *)message appearanceProcess:(JHAlertAppearanceProcess)appearanceProcess actionsBlock:(JHAlertActionBlock)actionBlock{
    if (appearanceProcess){
        JHAlertController *alertMaker = [[JHAlertController alloc] initAlertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        //防止nil
        if (!alertMaker) {
            return ;
        }
        //加工链
        appearanceProcess(alertMaker);
        //配置响应
        alertMaker.alertActionsConfig(actionBlock);
        
        if (alertMaker.alertDidShow){
            [[self getCurrentVC] presentViewController:alertMaker animated:!(alertMaker.setAlertAnimated) completion:^{
                alertMaker.alertDidShow();
            }];
        }else{
            [[self getCurrentVC] presentViewController:alertMaker animated:!(alertMaker.setAlertAnimated) completion:NULL];
        }
    }
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(JHAlertAppearanceProcess)appearanceProcess actionsBlock:(JHAlertActionBlock)actionBlock{
    [self showAlertWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(JHAlertAppearanceProcess)appearanceProcess actionsBlock:(JHAlertActionBlock)actionBlock{
    [self showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

+ (UIViewController*) findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if( [vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

+ (UIViewController *) getCurrentVC {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}
@end

