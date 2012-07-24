//
//  CreditCardUtil.h
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/17/12.
//  Copyright (c) 2012 Shaikh Sonny Aman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString_CreditCardUtil.h"
#import "CreditCardValidationRule.h"
typedef enum {
	CCTypeNotSet = 0,
	CCTypeUnknown,
	CCTypeMasterCard,
	CCTypeVisa,
	CCTypeDinersClub,
	CCTypeAmericanExpress,
	CCTypeDiscover
}CCType;

extern NSString* const kCreditCardNameUnknown;
extern NSString* const kCreditCardNameNotSet;
extern NSString* const kCreditCardNameMasterCard;
extern NSString* const kCreditCardNameVisa;
extern NSString* const kCreditCardNameDinersClub;
extern NSString* const kCreditCardNameAmericanExpress;
extern NSString* const kCreditCardNameDiscover;


@protocol CreditCardUtilDelegate <NSObject>
@optional
- (void) onCreditCardTypeChanged:(CCType)type;
- (void) onCreditCardNumberEntered:(NSString*) number isValid:(BOOL)yesOrNo isAccepted:(BOOL) yesOrNo;
- (void) onCreditCardExpiryDateEntered:(NSString*)date isValid:(BOOL)yesOrNo;
- (void) stoppedOnUnknownCreditCard;
- (void) stoppedOnUnacceptableCreditCard;
@end

@interface CreditCardUtil : NSObject<UITextFieldDelegate>

@property ( nonatomic, assign ) UITextField* txtCreditCard;
@property ( nonatomic, assign ) UITextField* txtExpiryDate;
@property ( nonatomic, assign ) UIImageView* creditCardIconView;
@property ( nonatomic, assign ) id<CreditCardUtilDelegate> delegate;
@property ( nonatomic, assign) CCType cardType;
@property ( nonatomic, assign) BOOL shouldStopEnteringUnknownCard;
@property ( nonatomic, assign) BOOL shouldStopEnteringUnacceptableCard;
@property ( nonatomic, strong ) NSMutableDictionary* creditCardFormats;
@property ( nonatomic, strong ) NSMutableArray* acceptedCreditCardTypes;
@property ( nonatomic, strong ) NSString* lastCreditCardNumberValue;
@property ( nonatomic, strong ) NSString* lastCreditCardExpiryDate;

#pragma mark - object methods
- (BOOL) isCreditCardTypeAccepted;
- (void) addAcceptedCreditCard:(CCType) type;

#pragma mark - IBAction
- (IBAction)creditCardTextChange:(id)sender;
- (IBAction)creditCardExpiryDateChange:(id)sender;

#pragma mark - constructors
- (id)initWithCreditCardTextField:(UITextField*)txtCC expiryDateField:(UITextField*)txtExpiry;
- (NSString*) formatCreditCardNumber:(NSString*) creditCardNumber;

#pragma mark - static helper methods

+ (UIImage*) getCreditCardIcon: (CCType) creditCardType;
+ (CCType) 	getCreditCardType: (NSString*) creditCardNumber;
+ (NSString*) getCreditCardName: (NSString*) creditCardNumber;

+ (NSString*) getCreditCardNameFromType:(CCType) creditCardType;
+ (unsigned int) getCreditCardValidLength:(NSString*) creditCardNumber;

/**
 * Validate credit card using luhn's method and also from length
 */
+ (BOOL) isValidCreditCard:(NSString*) creditCardNumber;
+ (BOOL) isValidExpiryDate:(NSString*) expiryDate;
@end
