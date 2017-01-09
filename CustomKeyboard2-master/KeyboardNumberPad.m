//
//  KeyboardNumberPad.m
//  CustomKeyboard2-master
//
//  Created by 黄海燕 on 17/1/4.
//  Copyright © 2017年 huanghy. All rights reserved.
//


#import "KeyboardNumberPad.h"
#import "NSMutableArray+Hanlder.h"
#define SCREEN_WDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define COLOR_LINE [UIColor colorWithRed:141/255. green:141/255. blue:141/255. alpha:1]
#define COLOR_BUTTON_GRAY [UIColor colorWithRed:210/255. green:213/255. blue:219/255. alpha:1]
#define COLOR_BUTTON_WRITE [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define COLOR_BUTTON_TITLE [UIColor colorWithRed:0 green:0 blue:0 alpha:1]

#pragma mark - ContentModel
@implementation ContentModel
- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle imageName:(NSString *)imageName
{
    self = [super init];
    if (self) {
        self.title = title;
        self.subTitle = subTitle;
        self.imageName = imageName;
    }
    return self;
}
@end

#pragma mark - KeyboardCell
@interface KeyboardCell()

@property(nonatomic, assign)NSInteger index;
@end

@implementation KeyboardCell
{
    UIButton *_btn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_btn setTitleColor:COLOR_BUTTON_TITLE forState:UIControlStateNormal];
        [_btn.titleLabel setNumberOfLines:0];
        [_btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_btn setBackgroundImage:[self makeImageWithColor:COLOR_BUTTON_WRITE] forState:UIControlStateNormal];
//        [_btn setBackgroundImage:[self makeImageWithColor:COLOR_BUTTON_GRAY] forState:UIControlStateHighlighted];
        [_btn setBackgroundImage:[self makeImageWithColor:COLOR_BUTTON_GRAY] forState:UIControlStateNormal];
        [_btn setBackgroundImage:[self makeImageWithColor:COLOR_BUTTON_WRITE] forState:UIControlStateHighlighted];

        [self addSubview:_btn];
    }
    return self;
}

- (void)setContentWithModel:(NSArray *)models index:(NSInteger)index
{
    self.index = index;
    ContentModel *model = models[index];
    if (model.imageName.length != 0) {
        
        [_btn setImage:[UIImage imageNamed:model.imageName] forState:UIControlStateNormal];
        //[self setBtnBackgroundImage:COLOR_BUTTON_GRAY colorHighlight:COLOR_BUTTON_WRITE];
         [self setBtnBackgroundImage:COLOR_BUTTON_WRITE colorHighlight:COLOR_BUTTON_GRAY];

    }else if(model.title.length != 0) {
        if (model.subTitle.length == 0) {
            UIFont *fontTitle;
//            if ([model.title isEqualToString:@"完成"]) {
//                fontTitle = [UIFont systemFontOfSize:18];
//                [self setBtnBackgroundImage:COLOR_BUTTON_GRAY colorHighlight:COLOR_BUTTON_WRITE];
//            }else {
                fontTitle = [UIFont systemFontOfSize:27];
                [self setBtnBackgroundImage:COLOR_BUTTON_WRITE colorHighlight:COLOR_BUTTON_GRAY];
//            }
            
            NSAttributedString *aStr = [[NSAttributedString alloc] initWithString:model.title
                                                                       attributes:@{NSFontAttributeName : fontTitle,
                                                                                    NSForegroundColorAttributeName : COLOR_BUTTON_TITLE}];
            [_btn setAttributedTitle:aStr forState:UIControlStateNormal];
        }else {
            
            NSString *str = [NSString stringWithFormat:@"%@\n%@",model.title,model.subTitle];
            NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:str];
            [aStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:27],
                                  NSForegroundColorAttributeName : COLOR_BUTTON_TITLE}
                          range:NSMakeRange(0, model.title.length)];
            
            NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
            [pStyle setParagraphSpacingBefore:-2];
            [pStyle setAlignment:NSTextAlignmentCenter];
            [aStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],
                                  NSForegroundColorAttributeName : COLOR_BUTTON_TITLE,
                                  NSKernAttributeName : @(1),
                                  NSParagraphStyleAttributeName : pStyle}
                          range:NSMakeRange(model.title.length+1, model.subTitle.length)];
            [_btn setAttributedTitle:aStr forState:UIControlStateNormal];

            [self setBtnBackgroundImage:COLOR_BUTTON_WRITE colorHighlight:COLOR_BUTTON_GRAY];
        }
    }
}

- (UIImage *)makeImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setBtnBackgroundImage:(UIColor *)colorNormal colorHighlight:(UIColor *)colorHighlight
{
    [_btn setBackgroundImage:[self makeImageWithColor:colorNormal] forState:UIControlStateNormal];
    [_btn setBackgroundImage:[self makeImageWithColor:colorHighlight] forState:UIControlStateHighlighted];
}

- (void)btnClickAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(keyBoardTapWithButtonIndex:)]) {
        [self.delegate keyBoardTapWithButtonIndex:self.index];
    }
}
@end


#pragma mark - KeyboardNumberPad
@interface KeyboardNumberPad()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>
@property(nonatomic, strong)NSMutableArray *contents;
@end

@implementation KeyboardNumberPad
#define Identifier @"Identifier"

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame
                                                        collectionViewLayout:layout];
        [collectionView registerClass:[KeyboardCell class] forCellWithReuseIdentifier:Identifier];
        [collectionView setDelegate:self];
        [collectionView setDataSource:self];
        [collectionView setBackgroundColor:COLOR_LINE];
        [collectionView setScrollEnabled:NO];
        [self addSubview:collectionView];
        
        NSArray *titles = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@"",@"", nil];
        NSArray *subTitles = [[NSArray alloc] initWithObjects:@" ",@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ",@"",@"",@"",@"", nil];
        NSArray *imageNames = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"fingerprint",@"",@"CalculatorBackspace", nil];
        self.contents = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < 12; index++) {
            ContentModel * model = [[ContentModel alloc] initWithTitle:titles[index] subTitle:subTitles[index] imageName:imageNames[index]];
            [self. contents ieAddObjcet:model];
        }
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contents.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WDTH - [self fixScreenWidth:5]) / 3., 54);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, [self fixScreenWidth:1], 0, [self fixScreenWidth:1]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return [self fixScreenWidth:1];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [self fixScreenWidth:1];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KeyboardCell *cell = (KeyboardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell setContentWithModel:self.contents index:indexPath.row];
    return cell;
}

- (CGFloat)fixScreenWidth:(CGFloat)width
{
    CGFloat newWidth = width / [[UIScreen mainScreen] scale];
    return newWidth;
}

#pragma mark - KeyboardNumberPad
- (void)keyBoardTapWithButtonIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(keyBoardTapWithContent:)]) {
        ContentModel *model = self.contents[index];
        NSString *content = nil;
        if ((index >=0 && index <9) || index == 10) {
            content = model.title;
        }else if (index == 9) {
            content = @"finish";
        }else if (index == 11) {
            content = @"";
        }
        [self.delegate keyBoardTapWithContent:content];
    }
}
@end
