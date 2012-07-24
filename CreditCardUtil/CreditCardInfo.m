//
//  CreditCardInfo.m
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/19/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import "CreditCardInfo.h"
#import "CreditCardIssuingNetwork.h"


@implementation CreditCardInfo
@synthesize issuingNetwork, cardNumber, numberFormat, hasValidCardNumber, isAccepted, formattedCardNumber, maximumAllowedLength;

-(NSString*)description{
	return [NSString stringWithFormat:@"Number:%@ \
\n Network:%@\
\n Max Length:%d\
\n Format:%@\
\n Formatted:%@\
\n hasValidCardNumber:%@\
\n isAccepted:%@"
			, cardNumber
			, issuingNetwork.networkName
			, maximumAllowedLength
			, numberFormat
			, formattedCardNumber
			, hasValidCardNumber == YES ? @"YES" : @"NO"
			, isAccepted == YES ? @"YES" : @"NO"];
}
@end
