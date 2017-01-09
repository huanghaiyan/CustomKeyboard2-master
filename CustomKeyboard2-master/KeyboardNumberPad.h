//
//  KeyboardNumberPad.h
//  CustomKeyboard2-master
//
//  Created by 黄海燕 on 17/1/4.
//  Copyright © 2017年 huanghy. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - ContentModel
@interface ContentModel : NSObject
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *subTitle;
@property(nonatomic, copy)NSString *imageName;
@end

#pragma mark - KeyboardCell
@protocol keyboardTapProtocol <NSObject>

- (void)keyBoardTapWithButtonIndex:(NSInteger)index;
@end

@interface KeyboardCell : UICollectionViewCell
@property(nonatomic, weak)id <keyboardTapProtocol>delegate;

- (void)setContentWithModel:(NSArray *)models index:(NSInteger)index;
@end

#pragma mark - KeyboardNumberPad
@protocol KeyboardNumberPadProtocol <NSObject>

- (void)keyBoardTapWithContent:(NSString *)content;
@end

@interface KeyboardNumberPad : UIView <keyboardTapProtocol>

@property(nonatomic, weak)id <KeyboardNumberPadProtocol>delegate;
@end
