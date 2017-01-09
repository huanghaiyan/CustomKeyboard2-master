//
//  IETextField.m
//  CustomKeyboard2-master
//
//  Created by 黄海燕 on 17/1/6.
//  Copyright © 2017年 huanghy. All rights reserved.
//

#import "IETextField.h"
#import "KeyboardNumberPad.h"
#import "Masonry.h"

#define SCREENT_WIDTH       [[UIScreen mainScreen] bounds].size.width
@interface IETextField () <KeyboardNumberPadProtocol>

@end

@implementation IETextField
{
    UIView *_leftView;
}

+ (instancetype)textFieldWithPlaceHolder:(NSString *)placeHolder
                           leftLabelText:(NSString *)labelText
                           leftLabelFont:(UIFont *)labelFont {
    
    IETextField *t = [[self alloc] init];
    t.placeholder = placeHolder;
    [t __makeLeftLabelWithText:labelText font:labelFont];
    
    return t;
}

- (NSString *)realText {
    return [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self __configUI];
    }
    return self;
}

- (void)__configUI {
    self.backgroundColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:15];
    //self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDefault;
}

- (void)__makeLeftLabelWithText:(NSString *)labelText font:(UIFont *)labelFont {
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 40)];

    if (labelText && ![self isEmptyStr:labelText]) {

        UIFont *font = labelFont == nil ? [UIFont systemFontOfSize:14] : labelFont;
        
        CGSize size = [labelText sizeWithAttributes:@{NSFontAttributeName:font}];
        
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, 30)];
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.backgroundColor = [UIColor whiteColor];
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.font = font;
        leftLabel.text = labelText;
 
        [_leftView addSubview:leftLabel];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(_leftView);
        }];
    }
    
    _leftView.backgroundColor = [UIColor clearColor];
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = _leftView;
}

- (void)setIsNumberPad:(BOOL)isNumberPad {
    _isNumberPad = isNumberPad;
    
    if (isNumberPad) {
        [self __setKeyboardType:UIKeyboardTypeNumberPad];
    }
}

- (void)__setKeyboardType:(UIKeyboardType)keyboardType {
    if (keyboardType != UIKeyboardTypeNumberPad) {
        [self setKeyboardType:keyboardType];
        return;
    }
    KeyboardNumberPad *view = [[KeyboardNumberPad alloc] initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, 216)];
    self.inputView = view;
    view.delegate = self;
}

#pragma mark KeyboardNumberPadProtocol
- (void)keyBoardTapWithContent:(NSString *)content {
    if ([content isEqualToString:@"finish"]) {
        //[self resignFirstResponder];
        if ([self.textFielddelegate respondsToSelector:@selector(fingerPrintTap)]) {
            [self.textFielddelegate fingerPrintTap];
        }
        return;
    }
    
    BOOL allowToHandel = YES;
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        NSRange range = [self __selectedNSRange];
        allowToHandel = [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:content];
    }
    
    if (allowToHandel) {
        if ([content isEqualToString:@""]) {
            [self deleteBackward];
        } else {
            [self insertText:content];
        }
    }
}

- (NSRange)__selectedNSRange {
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}


//判断是否为空字符串
- (BOOL)isEmptyStr:(NSString *)value {
    
    if ([value isKindOfClass:[NSNull class]] || !value) {
        return YES;
    }else if([value isKindOfClass:[NSString class]]) {
        value = [self trimStr:value];
        if (value.length == 0 || [value isEqualToString:@"(null)"]) {
            return YES;
        }
        return NO;
    }else if ([value isKindOfClass:[NSNumber class]]){
        value = [NSString stringWithFormat:@"%@",value];
        return [self isEmptyStr:value];
        
    }
    return YES;
}

//去除字符串前后空格
- (NSString *)trimStr:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
