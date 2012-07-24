//
//  CreditCardUtil.h
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/18/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString_CreditCardUtil.h"
#import "CreditCardIssuingNetwork.h"
#import "CreditCardInfo.h"

/**
 * This class can be used to check credit number and expiry date validation.
 * Credit card validation is done using Luhn's algorithm.
 * Expiry date is considered valid if it referes to a future time.
 *
 * To support more credity card network type, add a new network in  its init method.
 * 
 * To accept few of the issuing network, add them to acceptedCardNetworks list array.
 *
 */

@interface CreditCardUtil : NSObject

@property (nonatomic, strong) NSString* errorMessage;
@property (nonatomic, strong) NSMutableArray* creditCardTemplates;
@property (nonatomic, strong) NSMutableArray* acceptedCardNetworks;

/**
 * This method makes a CreditCardInfo object from a credit number.
 * If it cannot detect issuing network, it will return nil.
 *
 * If the issuing network is not acceptable by the application, which is
 * set by adding acceptedCardNetworks list, the method will return a CreditCardInfo
 * object with its isAcceptable flag set to NO.
 */
- (CreditCardInfo*) getCreditCardInfo:(NSString*)number;

/**
 * Returns true if the passed date refers to a future time.
 */
+ (BOOL) isValidExpiryDate:(NSString*)date;

@end
