//
//  CreditCardInputUtil.h
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/19/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardUtil.h"
#import "CreditCardInfo.h"

/**
 * This class is helps taking credit card and expiry date input.
 *
 * Credit number format is taken from the issuing network object set in CreditCartUtil class.
 */

typedef void (^t_CardNumberEntered)(CreditCardInfo* card);
typedef void (^t_ExpiryDateEntered)(int month, int year, BOOL isValid, BOOL isDone, CreditCardInfo* card);

@interface CreditCardInputUtil : CreditCardUtil<UITextFieldDelegate>


/**
 * Initialization method
 */
- (id)initWithCardNumberField:(UITextField*)numberField
			  expiryDateField:(UITextField*) dateField 
			cardEntryCallback:(t_CardNumberEntered)cardCallbackOrNil 
			dateEntryCallback:(t_ExpiryDateEntered)dateCallbackOrNil;
@end
