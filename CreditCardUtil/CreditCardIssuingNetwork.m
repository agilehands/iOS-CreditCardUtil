//
//  CreditCard.m
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/18/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import "CreditCardIssuingNetwork.h"
#define MAX_CARD_NUM_LENGTH_POSSIBLE  25
@implementation NSString (CreditCardIssuingNetwork)

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
	//char lastCharInCreditCardNumber = [self characterAtIndex:self.length -1];
	
	//BOOL isDeleting = chFormat[ self.length -1 ] == lastCharInCreditCardNumber;
	//printf("Last character:%c, chFormat[%d]:%c, isDeleting = %s \n", lastCharInCreditCardNumber, self.length -1, chFormat[ self.length -1 ], isDeleting == YES?"yes":"no");
	
	char chOut[MAX_CARD_NUM_LENGTH_POSSIBLE] = {'\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0','\0'};
	
	int i,j;
	
	for (i=0, j=0; i<length && j<trimmedCreditCardNumber.length; i++) {
		if ( chFormat[i] == 'x' || chFormat[i] == chNumber[j]) {
			chOut[i] = chNumber[j++];	
		} else {
			chOut[i] = chFormat[i];
		}
	}
	
	
//	if ( !isDeleting && i < length && chFormat[i]!='x') { // need to insert  formatting chars, assuming max 2
//		//printf("%s\n",chOut);
//		char c = chFormat[i];
//		//printf("%s,>%c<\n",chOut, c);
//		chOut[i] = c;
//		i++;
//		if ( i < length && chFormat[i]!='x') { // inserting 2nd format chars, if any
//			c = chFormat[i];
//			printf("%s,>%c<\n", chOut, c);
//			chOut[i] = c;
//			i++;
//		}
//	}
	
	chOut[i] = '\0';
	
	return [NSString stringWithUTF8String:chOut];
}
@end

#pragma mark - CreditCardIssuingNetwork Private
@interface CreditCardIssuingNetwork(Private)

- (BOOL) isValidCardNumber:( NSString*) creditCardNumber;
- (BOOL) isCandidateCard:( NSString*) creditCardNumber;
- (NSString*) getNumberFormat:( NSString*) creditCardNumber;
- (NSString*) formatCreditCardNumber:(NSString*) creditCardNumber;
@end

#pragma mark - CreditCardIssuingNetwork Implementation

@implementation CreditCardIssuingNetwork
@synthesize networkName, icon, validLengths, prefixes, validtionAlgorithm, errorMessage;
@synthesize numberFormats, dateFormat;

- (id) initWithName:(NSString*)name prefixes:(NSString*)prefixAndranges validCardLengths:(NSString*)lengths icon:(UIImage*)cardIcon validationAlgorithm:(t_CreditCardValidAlgorithm)algorithmOrNil{
	self = [super init];
	if (self) {
		self.networkName = name;
		
		// populate lengths
		self.validLengths = [NSMutableArray new];
		NSArray* commaTokens = [lengths componentsSeparatedByString:@","];
		for (NSString* range in commaTokens) {
			NSArray* tokens=  [range componentsSeparatedByString:@"-"];
			if ([tokens count] == 1){
				[validLengths addObject:[NSNumber numberWithInt:[[tokens objectAtIndex:0] intValue]]];
			} else {
				int start = [[tokens objectAtIndex:0] intValue];
				int end = [[tokens objectAtIndex:1] intValue];
				for (int i = start; i <=end; i++) {
					[validLengths addObject:[NSNumber numberWithInt:i]];					
				}
			}
		}
		// sort lengths in ascending order		
		[self.validLengths sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
			return [(NSNumber*)obj1 compare:obj2];
		}];
		
		self.validtionAlgorithm = algorithmOrNil;
		
		self.prefixes = [NSMutableArray new];
		
		commaTokens = [prefixAndranges componentsSeparatedByString:@","];
		for (NSString* range in commaTokens) {
			NSArray* tokens=  [range componentsSeparatedByString:@"-"];
			if ([tokens count] == 1){
				[prefixes addObject:[tokens objectAtIndex:0]];
			} else {
				int start = [[tokens objectAtIndex:0] intValue];
				int end = [[tokens objectAtIndex:1] intValue];
				for (int i = start; i <=end; i++) {
					[prefixes addObject:[NSString stringWithFormat:@"%d",i]];
				}
			}
		}		
		self.icon = cardIcon;
	}
	return self;	
}

- (BOOL) isValidCardNumber:( NSString*) cardNumber{
	self.errorMessage = @"";
	
	// check length
	if ([self.validLengths indexOfObject:[NSNumber numberWithInt:cardNumber.length]] == NSNotFound) {
		self.errorMessage = [NSString stringWithFormat:@"%@ doesn't have a valid length:%@",cardNumber, [validLengths componentsJoinedByString:@"or"]];
		return NO;
	}
	
	// check template method
	if (validtionAlgorithm) {
		self.errorMessage = [NSString stringWithFormat:@"%@ is not a valid:%@ card number",cardNumber, networkName];
		return validtionAlgorithm( cardNumber );
	}
	
	return YES;
}

- (BOOL) isCandidateCard:( NSString*) cardNumber{
	cardNumber = [cardNumber trimNonNumeric];
	// ignore null object or emtpy string
	if (!cardNumber || !cardNumber.length) {
		return NO;
	}
	
	BOOL yesOrNo = NO;
	
	for (NSString* prefix in prefixes) {		
		if ( cardNumber.length >= prefix.length) {			
			NSRange range =  [cardNumber rangeOfString:prefix];		
			if (range.location == 0 ) {
				//NSLog(@"%@ === >card number = %@, prefix = %@, %@", networkName, cardNumber, prefix,NSStringFromRange(range) );
				yesOrNo = YES;
				break;
			}			
		} else {
			NSRange range =  [prefix rangeOfString:cardNumber];		
			if (range.location == 0 ) {
				//NSLog(@"%@ === >card number = %@, prefix = %@, %@", networkName, cardNumber, prefix,NSStringFromRange(range) );
				yesOrNo = YES;
				break;
			}
		}
	}
	return yesOrNo;
}
- (NSString*) getNumberFormat:( NSString*) creditCardNumber{
	unsigned char len = creditCardNumber.length;
	unsigned char loopCount = [validLengths count];
	unsigned char length = 0;
	unsigned char i;
	for (i=0; i < loopCount; i++) {
		length =  [[validLengths objectAtIndex:i] intValue];
		if (len <= length ) {
			break;
		}
	}
	if (i == loopCount) { // card length bigger than valid
		length = [[validLengths objectAtIndex:i-1] intValue]; // return for the longest one
	}
	return [numberFormats valueForKey:[NSString stringWithFormat:@"%d",length]];
}

- (CreditCardInfo*) createCardWithNumber:(NSString*) cardNumber{
	NSString* trimmedCardNumber = [cardNumber trimNonNumeric];
	
	CreditCardInfo* card = nil;
	if ([self isCandidateCard:trimmedCardNumber]) {
		card = [CreditCardInfo new];
		card.cardNumber = trimmedCardNumber;
		card.issuingNetwork = self;
		card.hasValidCardNumber = [self isValidCardNumber:trimmedCardNumber];
		card.numberFormat = [self getNumberFormat:trimmedCardNumber];
		card.formattedCardNumber = [cardNumber format:card.numberFormat];
		card.maximumAllowedLength = [[validLengths lastObject] intValue];
	}
	return card;
}
@end
