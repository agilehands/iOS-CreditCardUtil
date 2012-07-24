//
//  CreditCardInputUtil.m
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/19/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import "CreditCardInputUtil.h"

@implementation CreditCardInputUtil
@synthesize shouldStopOnError, shouldStopOnNotAcceptableCards, shouldStopOnInvalidDateDetected, cardEntryCallback, dateEntryCallback;
@synthesize txtDateField, txtNumberField, dateFormat, card;

- (id)initWithCardNumberField:(UITextField*)numberField
			  expiryDateField:(UITextField*) dateField 
			cardEntryCallback:(t_CardNumberEntered)cardCallbackOrNil 
			dateEntryCallback:(t_ExpiryDateEntered)dateCallbackOrNil{
	self = [super init];
	if (self) {
		self.txtDateField = dateField;
		self.txtNumberField = numberField;
		self.cardEntryCallback = cardCallbackOrNil;
		self.dateEntryCallback = dateCallbackOrNil;
		
		self.txtNumberField.delegate = self;
		self.txtDateField.delegate = self;
		txtNumberField.keyboardType = UIKeyboardTypeNumberPad;
		txtDateField.keyboardType = UIKeyboardTypeNumberPad;
		
		self.shouldStopOnError = YES;
		self.shouldStopOnInvalidDateDetected = YES;
		self.shouldStopOnNotAcceptableCards =YES;
		
		
		self.dateFormat = @"xx/xx";
		
		[self.txtNumberField addTarget:self 
						   action:@selector(creditCardNumberChanged:) 
				 forControlEvents:UIControlEventEditingChanged];
		[self.txtDateField addTarget:self 
								action:@selector(expiryDateChanged:) 
					  forControlEvents:UIControlEventEditingChanged];
	}
	return self;
}

- (void)expiryDateChanged:(id)sender{
	static NSString* lastValue = nil;		
	if (lastValue && [lastValue compare:txtDateField.text] == NSOrderedSame) {
		return;
	}	
	lastValue = [txtDateField.text format:@"xx/xx"];	
	
	txtDateField.text = lastValue;
	NSArray* dateComp = [lastValue componentsSeparatedByString:@"/"];
	int year = -1;
	int month = [[dateComp objectAtIndex:0] intValue];
	if ([dateComp count] >1) {
		year = [[dateComp objectAtIndex:1] intValue] + 2000;
	}	
	
	BOOL isDone = NO;
	if (lastValue.length == dateFormat.length) {
		[txtDateField resignFirstResponder];
		isDone = YES;
	}
	if (self.dateEntryCallback) {
		self.dateEntryCallback(month, year, [CreditCardUtil isValidExpiryDate:lastValue], isDone, card);
	}
	
	if (isDone) {
		return;
	}
}
- (void)creditCardNumberChanged:(id)sender{
	if ( card && [card.formattedCardNumber compare:txtNumberField.text] == NSOrderedSame) {		
		return;
	}
	
	self.card = [self getCreditCardInfo:txtNumberField.text];
	if (card) {
		txtNumberField.text = card.formattedCardNumber;
	}	
	
	if (self.cardEntryCallback) {	
		self.cardEntryCallback(card);
	}	
}

#pragma mark - UITextField Delegate methods
- (void)textFieldDidEndEditing:(UITextField *)textField{
	if (textField == txtDateField) {
		if (txtDateField.text.length == 1) {
			txtDateField.text = @"";
		}
	}
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	if (textField == txtDateField) {		
		if (txtDateField.text.length == 0) {
			txtDateField.text = @" ";
		}
	}
	return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{	
	NSString* newValue = [textField.text stringByAppendingString:string];	
	
	NSLog(@"New val = %@ ( %d == %d)", newValue, newValue.length, (dateFormat.length));
	if (textField == txtNumberField) {
		if (string.length > 0 && textField.text.length > 0 && !card && shouldStopOnError) {
			return NO;
		}
		
		if (string.length > 5 && textField.text.length > 0 && !card.isAccepted && shouldStopOnNotAcceptableCards) {
			return NO;
		}
		
		NSLog(@"format = %@ (%d)",[card formattedCardNumber]  ,card.maximumAllowedLength);
		if ( card && ( [newValue trimNonNumeric].length > card.maximumAllowedLength)) {
			[txtDateField becomeFirstResponder];
			return NO;
		}
		
	} else if (textField == txtDateField) {		
		if (newValue.length == 1){
			//[textField resignFirstResponder];
			[txtNumberField becomeFirstResponder];
			return NO;
		}
	}
	return YES;
}
@end
