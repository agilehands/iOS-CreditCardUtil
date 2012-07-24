//
//  NSString_CreditCardFormatUtil.h
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/17/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CreditCardUtil)
- (NSString*)format:(NSString*)format;
- (NSString*)trimNonNumeric;
@end
