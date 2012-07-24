//
//  CreditCardUtil.m
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/17/12.
//  Copyright (c) 2012 Shaikh Sonny Aman. All rights reserved.
//

#import "CreditCardUtil.h"

NSString* const kCreditCardNameUnknown = @"Unknown";
NSString* const kCreditCardNameNotSet = @"Not set";
NSString* const kCreditCardNameMasterCard = @"Master Card";
NSString* const kCreditCardNameVisa = @"Visa";
NSString* const kCreditCardNameDinersClub = @"Diners Club";
NSString* const kCreditCardNameAmericanExpress = @"American Express";
NSString* const kCreditCardNameDiscover = @"Discover";

@implementation NSString (CreditCardUtil)
- (NSString*)trimNonNumeric{
	return [[self componentsSeparatedByCharactersInSet:
			 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] 
			componentsJoinedByString:@""];
}
- (NSString*) format:(NSString *)format{
	NSString* trimmedCreditCardNumber = [self trimNonNumeric];
	
	if (trimmedCreditCardNumber.length < 1) {
		return trimmedCreditCardNumber;
	}
	
	int length = format.length;
	
	unsigned char* chFormat = (unsigned char *)[format cStringUsingEncoding:NSASCIIStringEncoding];
	unsigned char* chNumber = (unsigned char *)[trimmedCreditCardNumber cStringUsingEncoding:NSASCIIStringEncoding];
	char lastCharInCreditCardNumber = [self characterAtIndex:self.length -1];
	
	BOOL isDeleting = chFormat[ self.length -1 ] == lastCharInCreditCardNumber;
	printf("Last character:%c, chFormat[%d]:%c, isDeleting = %s \n", lastCharInCreditCardNumber, self.length -1, chFormat[ self.length -1 ], isDeleting == YES?"yes":"no");
	
	char chOut[20] = {'\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0'};
	
	int i,j;
	
	for (i=0, j=0; i<length && j<trimmedCreditCardNumber.length; i++) {
		if ( chFormat[i] == 'x' || chFormat[i] == chNumber[j]) {
			chOut[i] = chNumber[j++];	
		} else {
			chOut[i] = chFormat[i];
		}
	}
	
	
	if ( !isDeleting && i < length && chFormat[i]!='x') { // need to insert  formatting chars, assuming max 2
		printf("%s\n",chOut);
		char c = chFormat[i];
		printf("%s,>%c<\n",chOut, c);
		chOut[i] = c;
		i++;
		if ( i < length && chFormat[i]!='x') { // inserting 2nd format chars, if any
			c = chFormat[i];
			printf("%s,>%c<\n", chOut, c);
			chOut[i] = c;
			i++;
		}
	}
	
	chOut[i] = '\0';
	
	return [NSString stringWithUTF8String:chOut];
}
@end

static NSMutableDictionary* icons = nil;
static NSMutableDictionary* names = nil;

#pragma mark - CreditCardUtil
@implementation CreditCardUtil
@synthesize txtCreditCard, txtExpiryDate, delegate, creditCardFormats;
@synthesize lastCreditCardNumberValue, lastCreditCardExpiryDate;
@synthesize acceptedCreditCardTypes, creditCardIconView, cardType;
@synthesize shouldStopEnteringUnknownCard, shouldStopEnteringUnacceptableCard;

#pragma mark - constructors
- (id) init{
	self = [super init];
	if (self) {
		self.shouldStopEnteringUnknownCard = YES;
		self.shouldStopEnteringUnacceptableCard = YES;
		self.lastCreditCardNumberValue = @"-1";
		self.lastCreditCardExpiryDate = @"-1";
		self.txtCreditCard = nil;
		self.txtExpiryDate = nil;
		self.acceptedCreditCardTypes = [NSMutableArray new];
		
		self.cardType = CCTypeUnknown;
		self.creditCardFormats = [NSMutableDictionary new];
		[creditCardFormats setValue:@"(xxxx) xxxx-xxxx-xxxx" forKey:[NSString stringWithFormat:@"%d", CCTypeVisa]];
		[creditCardFormats setValue:@"xxxx-xxxxxx-xxxxx" forKey:[NSString stringWithFormat:@"%d", CCTypeAmericanExpress]];
		[creditCardFormats setValue:@"xxxx-xxxx-xxxx-xxxx" forKey:[NSString stringWithFormat:@"%d", CCTypeMasterCard]];
		[creditCardFormats setValue:@"xxxx-xxxxxx-xxxx" forKey:[NSString stringWithFormat:@"%d", CCTypeDinersClub]];
		[creditCardFormats setValue:@"xxxx-xxxx-xxxx-xxxx" forKey:[NSString stringWithFormat:@"%d", CCTypeDiscover]];
	}
	return self;
}
- (id) initWithCreditCardTextField:(UITextField*)txtCC expiryDateField:(UITextField*)txtExpiry{
	self  =[self init];
	if (self) {
		self.txtCreditCard = txtCC;
		self.txtExpiryDate = txtExpiry;
		self.txtExpiryDate.delegate = self;
		self.txtCreditCard.delegate = self;
		
		[txtCreditCard addTarget:self 
						  action:@selector(creditCardTextChange:) 
				forControlEvents:UIControlEventEditingChanged];
		
		[txtExpiryDate addTarget:self 
						  action:@selector(creditCardExpiryDateChange:) 
				forControlEvents:UIControlEventEditingChanged];
	}
	return self;
}

- (NSString*) formatCreditCardNumber:(NSString*) creditCardNumber{
	NSLog(@"\n\nFormatting: >%@<", creditCardNumber);
	NSString* trimmedCreditCardNumber = [creditCardNumber trimNonNumeric];
	
	if (trimmedCreditCardNumber.length < 1) {
		return trimmedCreditCardNumber;
	}
	
	CCType type = [CreditCardUtil getCreditCardType:trimmedCreditCardNumber];
	if (type == CCTypeUnknown || type == CCTypeNotSet) {
		return creditCardNumber;
	}
	
	NSString* format = [creditCardFormats valueForKey:[NSString stringWithFormat:@"%d", type]];
	return [creditCardNumber format:format];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
	if (textField == txtExpiryDate) {
		if (self.delegate && [delegate respondsToSelector:@selector(onCreditCardExpiryDateEntered:isValid:)]) {
			[self.delegate onCreditCardExpiryDateEntered:txtExpiryDate.text isValid:[CreditCardUtil isValidExpiryDate:textField.text]];
		}		
	} else {
		if (self.delegate && [delegate respondsToSelector:@selector(onCreditCardNumberEntered:isValid:isAccepted:)]) {
			[self.delegate onCreditCardNumberEntered:textField.text 
											 isValid:[CreditCardUtil isValidCreditCard:textField.text] 
										  isAccepted: [self isCreditCardTypeAccepted] ];
		}		
	}
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	if (txtExpiryDate == textField) {
		if (txtExpiryDate.text.length == 0) {
			txtExpiryDate.text = @"\u200B";
		}
	}
	return YES;
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{		
	if (txtCreditCard == textField) { // credit card number
		if(string.length == 0)return YES;// backspace		
		
		if (txtCreditCard.text.length > 0) {
			if (shouldStopEnteringUnknownCard && cardType == CCTypeUnknown) {
				if (self.delegate && [delegate respondsToSelector:@selector(stoppedOnUnknownCreditCard)]) {
					[delegate stoppedOnUnknownCreditCard];
				}
				return NO;
			}
			
			if (shouldStopEnteringUnacceptableCard && ![self isCreditCardTypeAccepted]) {
				if (self.delegate && [delegate respondsToSelector:@selector(stoppedOnUnacceptableCreditCard)]) {
					[delegate stoppedOnUnacceptableCreditCard];
				}
				return NO;
			}
			
			int maxlen = [CreditCardUtil getCreditCardValidLength:txtCreditCard.text];
			int len = [txtCreditCard.text trimNonNumeric].length;
			if ( maxlen == len  ) {
				[txtExpiryDate becomeFirstResponder];
				return NO;
			}
		}		
		return YES;
	}  else { // expiry date
		if([txtExpiryDate.text trimNonNumeric].length == 4 && string.length != 0){
			[txtExpiryDate resignFirstResponder];			
			return NO;
		}
		if(txtExpiryDate.text.length == 1 && string.length == 0){
			txtExpiryDate.text = @"";
			[txtCreditCard becomeFirstResponder];
		}
	}
	
	return YES;
}
#pragma mark - object methods
- (BOOL) isCreditCardTypeAccepted{
	return [acceptedCreditCardTypes count] == 0 ? YES : ([acceptedCreditCardTypes indexOfObject:[NSNumber numberWithInt:cardType]] != NSNotFound);
}
- (void) addAcceptedCreditCard:(CCType) type{
	[self.acceptedCreditCardTypes addObject:[NSNumber numberWithInt:type]];
}
#pragma mark - IBAction
- (IBAction)creditCardTextChange:(id)sender{
	if ([lastCreditCardNumberValue compare:txtCreditCard.text] == NSOrderedSame) {
		return;
	}
	
	CCType type =  [CreditCardUtil getCreditCardType:txtCreditCard.text];
	BOOL changed = type != cardType;
	cardType = type;
	
	if (changed && self.delegate && [delegate respondsToSelector:@selector(onCreditCardTypeChanged:)]) {
		[delegate onCreditCardTypeChanged:cardType];
		// update icon
		if (self.creditCardIconView) {
			self.creditCardIconView.image = [CreditCardUtil getCreditCardIcon:cardType];
		}
	}	
	if (txtCreditCard) {
		NSString* fmt = [self formatCreditCardNumber: self.txtCreditCard.text];
		if ([lastCreditCardNumberValue compare:fmt] == NSOrderedSame) { // backspace pressed at non-numeric format like -,space etc
			return;
		}
		self.lastCreditCardNumberValue = fmt;
		txtCreditCard.text = fmt;	
		NSLog(@"Formatted: %@", fmt);
		if ([fmt trimNonNumeric].length > 0) {
			int maxlen = [CreditCardUtil getCreditCardValidLength:txtCreditCard.text];
			int len = [txtCreditCard.text trimNonNumeric].length;
			if ( maxlen == len  ) {
				[txtExpiryDate becomeFirstResponder];
				return;
			}
		}		
	}
}
- (IBAction)creditCardExpiryDateChange:(id)sender{
	if ([lastCreditCardExpiryDate compare:txtExpiryDate.text] == NSOrderedSame) {
		return;
	}	
	NSString* date = [txtExpiryDate.text format:@"xx/xx"];
	if ([lastCreditCardExpiryDate compare:date] == NSOrderedSame) { // backspace pressed at non-numeric format like -,space etc
		return;
	}
	lastCreditCardExpiryDate = date;
	txtExpiryDate.text = date;
	if (txtExpiryDate.text.length == 5) {
		[txtExpiryDate resignFirstResponder];
		return;
	}
}
#pragma mark - static helper methods

// logic: http://stackoverflow.com/questions/72768/how-do-you-detect-credit-card-type-based-on-number
+ (CCType)getCreditCardType:(NSString*) creditCardNumber{
	NSString* trimmed = [creditCardNumber trimNonNumeric];	
	
	CCType type = CCTypeUnknown;
	
	if (trimmed.length < 1) {
		return type;
	}	
	
	if ([[trimmed substringToIndex:1] intValue] == 4 ) {
		type = CCTypeVisa;
	} else if (trimmed.length >3 && [[trimmed substringToIndex:4] intValue] == 6011) {
		type = CCTypeDiscover;
	} else if (trimmed.length >1) {
		int firstTwoDigit = [[trimmed substringToIndex:2] intValue];	
		switch (firstTwoDigit) {
			case 34:
			case 37:
				type = CCTypeAmericanExpress;
				break;
			case 38:
			case 36:
				type = CCTypeDinersClub;
				break;
			case 51:
			case 52:
			case 53:
			case 54:
			case 55:
				type = CCTypeMasterCard;
				break;
			case 65:
				type = CCTypeDiscover;
				break;
			default:{
				// now check for 3 digits
				if (trimmed.length >2) {
					int firstThreeDigit = [[trimmed substringToIndex:3] intValue];
					switch (firstThreeDigit) {
						case 300:
						case 301:
						case 302:
						case 303:
						case 304:
						case 305:
							type = CCTypeDinersClub;
							break;						
						default:							
							type = CCTypeUnknown;
							break;
					}
				}				
			}
		}
	}
	
	if (type == CCTypeUnknown ) {
		if ([[trimmed substringToIndex:1] intValue] == 5 ){ // esp type of diners club with MasterClub
			type = CCTypeDinersClub;
		}
	}
	return type;
}

+ (unsigned int) getCreditCardValidLength:(NSString*) creditCardNumber{
	unsigned int len = 0;
	CCType type = [CreditCardUtil getCreditCardType:creditCardNumber];
	switch (type) {
		case CCTypeAmericanExpress:
			len = 15;
			break;
		case CCTypeDiscover:
		case CCTypeMasterCard:
		case CCTypeVisa:
			len = 16;
			break;		
		case CCTypeDinersClub:{
			if ([[[creditCardNumber trimNonNumeric] substringToIndex:1] intValue] == 5 ){ // esp type of diners club with MasterClub
				len = 16;
			} else {
				len = 14;
			}			
		}
			break;		
		default:
			break;
	}
	return len;
}

+ (BOOL) isValidCreditCard:(NSString*) creditCardNumber{
	// first check length
	CCType type = [CreditCardUtil getCreditCardType:creditCardNumber];
	if (type == CCTypeUnknown || type == CCTypeNotSet) {
		return NO;
	}
	
	if ( creditCardNumber.length != [CreditCardUtil getCreditCardValidLength:creditCardNumber]) {
		return NO;
	}
	
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
}

+ (UIImage*) getCreditCardIcon:(CCType) creditCardType{	
	static dispatch_once_t onceToken;	
	dispatch_once(&onceToken, ^{
		icons = [NSMutableDictionary new];
		[icons setValue:[UIImage imageNamed:@"credit_card_unknown.png"] forKey: [NSString stringWithFormat:@"%d", CCTypeNotSet]];
		[icons setValue:[UIImage imageNamed:@"credit_card_unknown.png"] forKey: [NSString stringWithFormat:@"%d", CCTypeUnknown]];
		[icons setValue:[UIImage imageNamed:@"credit_card_americanexpress@2x.png"] forKey: [NSString stringWithFormat:@"%d", CCTypeAmericanExpress]];
		[icons setValue:[UIImage imageNamed:@"credit_card_visa@2x.png"] forKey: [NSString stringWithFormat:@"%d", CCTypeVisa]];
		[icons setValue:[UIImage imageNamed:@"credit_card_mastercard@2x.png"] forKey: [NSString stringWithFormat:@"%d", CCTypeMasterCard]];
		[icons setValue:[UIImage imageNamed:@"credit_card_dnersclub@2x.png"] forKey: [NSString stringWithFormat:@"%d", CCTypeDinersClub]];
		[icons setValue:[UIImage imageNamed:@"credit_card_discover@2x.png"] forKey: [NSString stringWithFormat:@"%d", CCTypeDiscover]];
	});
	
	id icon = [icons valueForKey:[NSString stringWithFormat:@"%d",creditCardType]];
	if (!icon || icon == [NSNull null]) {
		icon = [icons valueForKey:[NSString stringWithFormat:@"%d",CCTypeUnknown]];
	}
	return (UIImage*)icon;
}
+ (NSString*) getCreditCardName:(NSString*) creditCardNumber{
		
	CCType creditCardType = [CreditCardUtil getCreditCardType:creditCardNumber];
	return [CreditCardUtil getCreditCardNameFromType:creditCardType];
}
+ (NSString*) getCreditCardNameFromType:(CCType) creditCardType{
	static dispatch_once_t onceToken;	
	dispatch_once(&onceToken, ^{
		names = [NSMutableDictionary new];
		[names setValue: kCreditCardNameNotSet forKey: [NSString stringWithFormat:@"%d", CCTypeNotSet]];
		[names setValue: kCreditCardNameUnknown forKey: [NSString stringWithFormat:@"%d", CCTypeUnknown]];
		[names setValue: kCreditCardNameAmericanExpress forKey: [NSString stringWithFormat:@"%d", CCTypeAmericanExpress]];
		[names setValue: kCreditCardNameVisa forKey: [NSString stringWithFormat:@"%d", CCTypeVisa]];
		[names setValue: kCreditCardNameMasterCard forKey: [NSString stringWithFormat:@"%d", CCTypeMasterCard]];
		[names setValue: kCreditCardNameDinersClub forKey: [NSString stringWithFormat:@"%d", CCTypeDinersClub]];
		[names setValue: kCreditCardNameDiscover forKey: [NSString stringWithFormat:@"%d", CCTypeDiscover]];
	});	
	
	id name = [names valueForKey:[NSString stringWithFormat:@"%d",creditCardType]];
	if (!name || name == [NSNull null]) {
		name = [names valueForKey:[NSString stringWithFormat:@"%d",CCTypeUnknown]];
	}
	return (NSString*)name;
}

+ (BOOL) isValidExpiryDate:(NSString*) expiryDate{

	if (expiryDate.length< 5) {	// invalid length
		return NO;
	}
	int month = [[[expiryDate componentsSeparatedByString:@"/"] objectAtIndex:0] intValue];
	int year = [[[expiryDate componentsSeparatedByString:@"/"] objectAtIndex:1] intValue] + 2000;
	
	if (! (month > 0 && month < 13)) {	// invalid month range	
		return NO;
	}
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
	int curYear =  [components year];
	int curMonth = [components month];
	
	if ( curYear > year ) { // Past year		
		return NO;
	} else if ( curYear == year && curMonth > month ) { // past month of this year		
		return NO;
	}
	
	return YES;
}
@end
