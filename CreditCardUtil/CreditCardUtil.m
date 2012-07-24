//
//  CreditCardUtil.m
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/18/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import "CreditCardUtil.h"

@implementation CreditCardUtil
@synthesize creditCardTemplates, acceptedCardNetworks, errorMessage;

- (id)init{
	self = [super init];
	if (self) {
		self.acceptedCardNetworks = [NSMutableArray new];
		self.creditCardTemplates = [NSMutableArray new];
		
		t_CreditCardValidAlgorithm luhnsAlogorithm = ^BOOL(NSString* creditCardNumber){
			// now luhn's method
			// The code is originally taken from http://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers#Objective-C
			NSMutableArray *stringAsChars = [[NSMutableArray alloc] initWithCapacity:[creditCardNumber length]];
			for (int i=0; i < [creditCardNumber length]; i++) {
				NSString *ichar  = [NSString stringWithFormat:@"%c", [creditCardNumber characterAtIndex:i]];
				[stringAsChars addObject:ichar];
			}
			
			BOOL isOdd = YES;
			int oddSum = 0;
			int evenSum = 0;
			
			for (int i = [creditCardNumber length] - 1; i >= 0; i--) {
				
				int digit = [(NSString *)[stringAsChars objectAtIndex:i] intValue];
				
				if (isOdd) 
					oddSum += digit;
				else 
					evenSum += digit/5 + (2*digit) % 10;
				
				isOdd = !isOdd;				 
			}
			
			return ((oddSum + evenSum) % 10 == 0);
		};
		
		// Add issuing networks to be able to deteect them.
		
		//http://en.wikipedia.org/wiki/Credit_card_numbers
		CreditCardIssuingNetwork* t1 = [[CreditCardIssuingNetwork alloc] initWithName:@"American Express" 
																   prefixes:@"34,37" 
														   validCardLengths:@"15" 
																	   icon:[UIImage imageNamed:@"credit_card_americanexpress@2x"] 
														validationAlgorithm: luhnsAlogorithm];
		t1.numberFormats = [NSDictionary dictionaryWithObject:@"(xxxxx) xxxx-xxxxxx" forKey:@"15"];
		
		CreditCardIssuingNetwork* t2 = [[CreditCardIssuingNetwork alloc] initWithName:@"Bankcard" 
																	prefixes:@"5610,560221-560225"
															validCardLengths:@"16"
																		icon:[UIImage imageNamed:@"credit_card_unknown"] 
														 validationAlgorithm: luhnsAlogorithm];
		
		t2.numberFormats = [NSDictionary dictionaryWithObject:@"xxxx-xxxx-xxxx-xxxx" forKey:@"16"];
				
		CreditCardIssuingNetwork* t3 = [[CreditCardIssuingNetwork alloc] initWithName:@"China UnionPay" 
																			   prefixes:@"62" 
																		validCardLengths:@"16-19"
																				   icon:[UIImage imageNamed:@"credit_card_unknown"] 
																	validationAlgorithm: nil];
		t3.numberFormats = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"xxxx-xxxx-xxxx-xxxx"
																, @"xxxx-xxxx-xxxx-xxxxx"
																, @"xxxx-xxxx-xxxx-xxxxxx"
																, @"xxxx-xxxx-xxxx-xxxxxxx"
																,  nil] 
														forKeys: [NSArray arrayWithObjects:@"16"
																  , @"17"
																  , @"18"
																  , @"19"
																  , nil]];
		
		CreditCardIssuingNetwork* t4 = [[CreditCardIssuingNetwork alloc] initWithName:@"Diners Club Carte Blanche" 
																 prefixes:@"300-305"
														 validCardLengths:@"14" 
																	 icon:[UIImage imageNamed:@"credit_card_dinersclub@2x"] 
													  validationAlgorithm: luhnsAlogorithm];
		t4.numberFormats = [NSDictionary dictionaryWithObject:@"xxxx-xxxx-xxxxxx" forKey:@"14"];
		
		CreditCardIssuingNetwork* t5 = [[CreditCardIssuingNetwork alloc] initWithName:@"Diners Club enRoute" 
																 prefixes:@"2014,2149"
														 validCardLengths:@"15" 
																	 icon:[UIImage imageNamed:@"credit_card_dinersclub@2x"] 
													  validationAlgorithm: nil];
		t5.numberFormats = [NSDictionary dictionaryWithObject:@"xxxxx-xxxx-xxxxxx" forKey:@"15"];
		
		CreditCardIssuingNetwork* t6 = [[CreditCardIssuingNetwork alloc] initWithName:@"Diners Club International" 
																 prefixes:@"36" 
														 validCardLengths:@"14" 
																	 icon:[UIImage imageNamed:@"credit_card_dinersclub@2x"] 
													  validationAlgorithm: luhnsAlogorithm];
		t6.numberFormats = [NSDictionary dictionaryWithObject:@"xxxx-xxxx-xxxxxx" forKey:@"14"];
		
		CreditCardIssuingNetwork* t7 = [[CreditCardIssuingNetwork alloc] initWithName:@"Diners Club US & Canada" 
																					 prefixes:@"5"
																			  validCardLengths:@"16" 
																						 icon:[UIImage imageNamed:@"credit_card_dinersclub@2x"] 
																		  validationAlgorithm: luhnsAlogorithm];
		t7.numberFormats = [NSDictionary dictionaryWithObject:@"xxxx-xxxx-xxxx-xxxx" forKey:@"16"];
		
		
		CreditCardIssuingNetwork* t8 = [[CreditCardIssuingNetwork alloc] initWithName:@"Discover Card" 
																 prefixes:@"30,36,38,39,6011,622126-622925,644-649,65"
														 validCardLengths:@"16" 
																	 icon:[UIImage imageNamed:@"credit_card_discover@2x"] 
													  validationAlgorithm: luhnsAlogorithm];
		t8.numberFormats = [NSDictionary dictionaryWithObject:@"xxxx-xxxx-xxxx-xxxx" forKey:@"16"];
		
		CreditCardIssuingNetwork* t9 = [[CreditCardIssuingNetwork alloc] initWithName:@"Insta Payment" 
																 prefixes:@"637-639" 
														 validCardLengths:@"16" 
																	 icon:[UIImage imageNamed:@"credit_card_unknown"] 
													  validationAlgorithm: luhnsAlogorithm];
		t9.numberFormats = [NSDictionary dictionaryWithObject:@"xxxx-xxxx-xxxx-xxxx" forKey:@"16"];
		
		CreditCardIssuingNetwork* t10 = [[CreditCardIssuingNetwork alloc] initWithName:@"JCB" 
																 prefixes:@"3528-3589" 
														 validCardLengths:@"16"
																	 icon:[UIImage imageNamed:@"credit_card_unknown"] 
													  validationAlgorithm: luhnsAlogorithm];
		t10.numberFormats = [NSDictionary dictionaryWithObject:@"xxxx-xxxx-xxxx-xxxx" forKey:@"16"];
		
		CreditCardIssuingNetwork* t11 = [[CreditCardIssuingNetwork alloc] initWithName:@"Laser" 
																 prefixes:@"6304,6706,6771,6709" 
														 validCardLengths:@"16-19"
																	 icon:[UIImage imageNamed:@"credit_card_unknown"] 
													  validationAlgorithm: luhnsAlogorithm];
		t11.numberFormats = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"xxxx-xxxx-xxxx-xxxx"
																, @"xxxx-xxxx-xxxx-xxxxx"
																, @"xxxx-xxxx-xxxx-xxxxxx"
																, @"xxxx-xxxx-xxxx-xxxxxxx"
																,  nil] 
													   forKeys: [NSArray arrayWithObjects:@"16"
																 , @"17"
																 , @"18"
																 , @"19"
																 , nil]];
		
		CreditCardIssuingNetwork* t12 = [[CreditCardIssuingNetwork alloc] initWithName:@"Maestro" 
																 prefixes:@"6304,6706,6771,6709"
														 validCardLengths:@"12-19"
																	 icon:[UIImage imageNamed:@"credit_card_unknown"] 
													  validationAlgorithm: luhnsAlogorithm];
		t12.numberFormats = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"xxxx-xxxx-xxxx"
																, @"xxxx-xxxx-xxxx-x"
																, @"xxxx-xxxx-xxxx-xx" 
																 , @"xxxx-xxxx-xxxx-xxx" 
																, @"xxxx-xxxx-xxxx-xxxx"
																, @"xxxx-xxxx-xxxx-xxxxx"
																, @"xxxx-xxxx-xxxx-xxxxxx"
																, @"xxxx-xxxx-xxxx-xxxxxxx"
																,  nil] 
													   forKeys: [NSArray arrayWithObjects:@"12"
																 , @"13"
																 , @"14"
																 , @"15"
																 , @"16"
																 , @"17"
																 , @"18"
																 , @"19"
																 , nil]];
		
		CreditCardIssuingNetwork* t13 = [[CreditCardIssuingNetwork alloc] initWithName:@"MasterCard" 
																 prefixes:@"51-55"
														 validCardLengths:@"16"
																	 icon:[UIImage imageNamed:@"credit_card_mastercard@2x"] 
													  validationAlgorithm: luhnsAlogorithm];
		t13.numberFormats = [NSDictionary dictionaryWithObject:@"xxxx-xxxx-xxxx-xxxx" forKey:@"16"];
		
		CreditCardIssuingNetwork* t14 = [[CreditCardIssuingNetwork alloc] initWithName:@"Solo" 
																 prefixes:@"6334,6767"
														 validCardLengths:@"16,19,18"
																	 icon:[UIImage imageNamed:@"credit_card_unknown"] 
													  validationAlgorithm: luhnsAlogorithm];
		t14.numberFormats = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"xxxx-xxxx-xxxx-xxxx"
																 , @"xxxx-xxxx-xxxx-xxxxxx"
																 , @"xxxx-xxxx-xxxx-xxxxxxx"
																 ,  nil] 
														forKeys: [NSArray arrayWithObjects:@"16"
																  , @"18"
																  , @"19"
																  , nil]];
		
		CreditCardIssuingNetwork* t15 = [[CreditCardIssuingNetwork alloc] initWithName:@"Switch" 
																 prefixes:@"4903,4905,4911,4936,564182,633110,6333,6759"
														 validCardLengths:@"16,18,19"
																	 icon:[UIImage imageNamed:@"credit_card_unknown"] 
													  validationAlgorithm: luhnsAlogorithm];
		t15.numberFormats = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"xxxx-xxxx-xxxx-xxxx"
																 , @"xxxx-xxxx-xxxx-xxxxxx"
																 , @"xxxx-xxxx-xxxx-xxxxxxx"
																 ,  nil] 
														forKeys: [NSArray arrayWithObjects:@"16"
																  , @"19"
																  , @"18"
																  , nil]];
		
		
				
		CreditCardIssuingNetwork* t16 = [[CreditCardIssuingNetwork alloc] initWithName:@"Visa" 
																   prefixes:@"4"
														   validCardLengths:@"16,13" 
																	   icon:[UIImage imageNamed:@"credit_card_visa@2x"] 
														validationAlgorithm: luhnsAlogorithm];
		t16.numberFormats = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"xxxx-xxxx-xxxx-xxxx"
																 , @"xxxx-xxxx-xxxx-x"
																 ,  nil] 
														forKeys: [NSArray arrayWithObjects:@"16"
																  , @"13"
																  , nil]];
		
		CreditCardIssuingNetwork* t17 = [[CreditCardIssuingNetwork alloc] initWithName:@"Visa Electron" 
																 prefixes:@"4026,417500,4508,4844,4913,4917"
														 validCardLengths:@"16" 
																	 icon:[UIImage imageNamed:@"credit_card_visa@2x"] 
													  validationAlgorithm: luhnsAlogorithm];
		t17.numberFormats = [NSDictionary dictionaryWithObject:@"xxxx-xxxx-xxxx-xxxx" forKey:@"16"];
		
		
		[self.creditCardTemplates addObject:t1];
		[self.creditCardTemplates addObject:t2];		
		[self.creditCardTemplates addObject:t3];		
		[self.creditCardTemplates addObject:t4];
		[self.creditCardTemplates addObject:t5];
		[self.creditCardTemplates addObject:t6];
		[self.creditCardTemplates addObject:t7];
		[self.creditCardTemplates addObject:t8];
		[self.creditCardTemplates addObject:t9];
		[self.creditCardTemplates addObject:t10];
		[self.creditCardTemplates addObject:t11];
		[self.creditCardTemplates addObject:t12];
		[self.creditCardTemplates addObject:t13];
		[self.creditCardTemplates addObject:t14];
		[self.creditCardTemplates addObject:t15];
		[self.creditCardTemplates addObject:t16];
		[self.creditCardTemplates addObject:t17];
				
//		[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s : %d",__PRETTY_FUNCTION__, __LINE__] 
//								   message:@"If your application supports only some specific credit card issuing networks then add it here or uncomment this alert!" 
//								  delegate:nil 
//						 cancelButtonTitle:@"Ok" 
//						 otherButtonTitles:nil] show];
		
		// Add acceptable networks for the app
		[self.acceptedCardNetworks addObject:t1];
		[self.acceptedCardNetworks addObject:t6];
		[self.acceptedCardNetworks addObject:t7];
		[self.acceptedCardNetworks addObject:t8];
		[self.acceptedCardNetworks addObject:t13];
		[self.acceptedCardNetworks addObject:t16];
	}
	return self;
}

- (CreditCardInfo*) getCreditCardInfo:(NSString*)number{
	CreditCardInfo* card = nil;
	for (CreditCardIssuingNetwork* network in creditCardTemplates) {	
		card = [network createCardWithNumber:number];
		if (card) {
			card.isAccepted = [acceptedCardNetworks indexOfObject:card.issuingNetwork] != NSNotFound;
			return card;
		}
	}
	return card;
}
+ (BOOL) isValidExpiryDate:(NSString*)expiryDate{
	if (expiryDate.length< 5) {	// invalid length
		return NO;
	}
	
	NSArray* dateComps = [expiryDate componentsSeparatedByString:@"/"];
	int month = [[dateComps objectAtIndex:0] intValue];
	
	if (! (month > 0 && month < 13)) {	// invalid month range	
		return NO;
	}
	if ([dateComps count] == 2) {
		int year = [[[expiryDate componentsSeparatedByString:@"/"] objectAtIndex:1] intValue] + 2000;
		
		NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
		int curYear =  [components year];
		int curMonth = [components month];
		
		if ( curYear > year ) { // Past year		
			return NO;
		} else if ( curYear == year && curMonth > month ) { // past month of this year		
			return NO;
		}
	} else {
		return NO;
	}	
	return YES;
}
@end
