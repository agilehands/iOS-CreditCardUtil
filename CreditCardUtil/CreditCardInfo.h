//
//  CreditCardInfo.h
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/19/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreditCardIssuingNetwork;

@interface CreditCardInfo : NSObject
@property (nonatomic, strong) CreditCardIssuingNetwork* issuingNetwork;
@property (nonatomic, strong) NSString* cardNumber;
@property (nonatomic, strong) NSString* numberFormat;
@property (nonatomic, strong) NSString* formattedCardNumber;
@property (nonatomic, assign) BOOL hasValidCardNumber;
@property (nonatomic, assign) BOOL isAccepted;
@property (nonatomic, assign) int maximumAllowedLength;

@end
