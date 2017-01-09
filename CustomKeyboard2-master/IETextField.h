//
//  IETextField.h
//  CustomKeyboard2-master
//
//  Created by 黄海燕 on 17/1/6.
//  Copyright © 2017年 huanghy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IETextFieldProtocol <NSObject>

- (void)fingerPrintTap;

@end

@interface IETextField : UITextField

/// 创建自定义TextField
///
/// 左侧标题默认字体大小：14，textField默认字体大小：15
///
/// @param placeHolder
/// @param labelText   左侧Label标题（传nil表示左侧标题不存在）
/// @param labelFont   左侧Label字体大小（传nil表示默认字体大小）
///
/// @return IETextField
+ (instancetype)textFieldWithPlaceHolder:(NSString *)placeHolder
                           leftLabelText:(NSString *)labelText
                           leftLabelFont:(UIFont *)labelFont;

/// 是否是数字键盘
@property (nonatomic, assign) BOOL isNumberPad;
/// 去除空格后的text
@property (nonatomic, copy) NSString *realText;

@property (nonatomic ,unsafe_unretained)id <IETextFieldProtocol> textFielddelegate;

@end
