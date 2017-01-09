//
//  UITextField+Keyboard.h
//  CustomKeyboard2-master
//
//  Created by 黄海燕 on 17/1/5.
//  Copyright © 2017年 huanghy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardNumberPad.h"

@interface UITextField (Keyboard) <KeyboardNumberPadProtocol>

- (void)setTextFieldKeyboardType:(UIKeyboardType)keyboardType;

@end
