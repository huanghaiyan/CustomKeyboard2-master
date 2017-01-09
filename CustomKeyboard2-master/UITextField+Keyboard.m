//
//  UITextField+Keyboard.m
//  CustomKeyboard2-master
//
//  Created by 黄海燕 on 17/1/5.
//  Copyright © 2017年 huanghy. All rights reserved.
//

#import "UITextField+Keyboard.h"

#define SCREENT_WIDTH       [[UIScreen mainScreen] bounds].size.width
@implementation UITextField (Keyboard)
- (void)setTextFieldKeyboardType:(UIKeyboardType)keyboardType
{
    if (keyboardType != UIKeyboardTypeNumberPad) {
        [self setKeyboardType:keyboardType];
        return;
    }
    KeyboardNumberPad *view = [[KeyboardNumberPad alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, 216)];
    self.inputView = view;
    view.delegate = self;
}


- (NSRange)selectedNSRange
{
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

#pragma mark KeyboardNumberPadProtocol
- (void)keyBoardTapWithContent:(NSString *)content
{
    if ([content isEqualToString:@"finish"]) {
        [self resignFirstResponder];
        return;
    }

    BOOL allowToHandel = YES;
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        NSRange range = [self selectedNSRange];
        allowToHandel = [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:content];
    }
    
    if (allowToHandel) {
        if ([content isEqualToString:@""]) {
            [self deleteBackward];
        }else {
            [self insertText:content];
        }
    }
}


@end
