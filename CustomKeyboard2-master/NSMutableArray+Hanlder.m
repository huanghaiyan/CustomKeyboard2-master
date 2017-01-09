//
//  NSMutableArray+Hanlder.m
//  CustomKeyboard2-master
//
//  Created by 黄海燕 on 17/1/6.
//  Copyright © 2017年 huanghy. All rights reserved.
//

#import "NSMutableArray+Hanlder.h"

@implementation NSMutableArray (Hanlder)

- (BOOL)ieAddObjcet:(id)object
{
    if (!object || [object isKindOfClass:[NSNull class]]) {
        return NO;
    }
    [self addObject:object];
    
    return YES;
}
@end
