//c   c       ํ      mber.h
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014ๅนด itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJIvar.h"
#import "MJMethod.h"

/**
 *  ้ๅๆๆ็ฑป็block๏ผ็ถ็ฑป๏ผ
 */
typedef void (^MJClassesBlock)(Class c, BOOL *stop);

@interface NSObject (MJMember)

/**
 *  ้ๅๆๆ็ๆๅๅ้
 */
- (void)enumerateIvarsWithBlock:(MJIvarsBlock)block;

/**
 *  ้ๅๆๆ็ๆนๆณ
 */
- (void)enumerateMethodsWithBlock:(MJMethodsBlock)block;

/**
 *  ้ๅๆๆ็็ฑป
 */
- (void)enumerateClassesWithBlock:(MJClassesBlock)block;
@end
