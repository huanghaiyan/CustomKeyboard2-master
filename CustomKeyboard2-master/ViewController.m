//
//  ViewController.m
//  CustomKeyboard2-master
//
//  Created by 黄海燕 on 17/1/5.
//  Copyright © 2017年 huanghy. All rights reserved.
//

#import "ViewController.h"
#import "KeyboardNumberPad.h"
#import "IETextField.h"
#import "UITextField+Keyboard.h"
@interface ViewController ()<IETextFieldProtocol>

@property(nonatomic, strong) IETextField *textF;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.textF = [IETextField textFieldWithPlaceHolder:@"hh" leftLabelText:nil leftLabelFont:nil];
    self.textF.textFielddelegate = self;
    self.textF.frame = CGRectMake(100, 100, 200, 26);
    [self.textF setTextFieldKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.textF];
    
    
}

-(void)fingerPrintTap{
    NSLog(@"指纹");
}

#pragma mark - 处理视图响应事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textF resignFirstResponder];
}



@end
