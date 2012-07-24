//
//  CreditCardUtilDemoTests.m
//  CreditCardUtilDemoTests
//
//  Created by Shaikh Sonny Aman on 7/17/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import "CreditCardUtilDemoTests.h"
#import "CreditCardUtil.h"
@implementation CreditCardUtilDemoTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreditCardType{

    NSArray* creditCardTestNumbers = [NSArray arrayWithObjects:@"378282246310005"
									  , @"371449635398431"
									  , @"30569309025904"
									  , @"38520000023237"
									  , @"6011111111111117"
									  , @"6011000990139424"
									  , @"5555555555554444"
									  , @"5105105105105100"
									  , @"4111111111111111"
									  , @"4012888888881881"
									  , nil];
	
	int types[10] = { CCTypeAmericanExpress
					, CCTypeAmericanExpress 
					, CCTypeDinersClub
					, CCTypeDinersClub
					, CCTypeDiscover
					, CCTypeDiscover
					, CCTypeMasterCard
					, CCTypeMasterCard
					, CCTypeVisa
					, CCTypeVisa
					};
	for (int i=0; i<[creditCardTestNumbers count]; i++) {
		NSString* num = [creditCardTestNumbers objectAtIndex:i];
		CCType type = types[i];
		CCType res = [CreditCardUtil getCreditCardType:num];
		STAssertEquals( type, res,@"Wrong credit cardtype for %@: expected = %@, returned = %@"
					   , num
					   , [CreditCardUtil getCreditCardNameFromType:type]
					   , [CreditCardUtil getCreditCardNameFromType:res]);
	}

}
- (void)testCreditCardValidation{
	
    NSArray* creditCardTestNumbers = [NSArray arrayWithObjects:@"378282246310005"
									  , @"371449635398431"
									  , @"30569309025904"
									  , @"38520000023237"
									  , @"6011111111111117"
									  , @"6011000990139424"
									  , @"5555555555554444"
									  , @"5105105105105100"
									  , @"4111111111111111"
									  , @"4222222222222"
									  , nil];
	
	int types[10] = { YES
		, YES 
		, YES
		, YES
		, YES
		, YES
		, YES
		, YES
		, YES
		, NO
	};
	for (int i=0; i<[creditCardTestNumbers count]; i++) {
		NSString* num = [creditCardTestNumbers objectAtIndex:i];
		BOOL valid = types[i];
		BOOL res = [CreditCardUtil isValidCreditCard:num];
		STAssertEquals( valid, res,@"Wrong credit cardtype for %@: expected = %d, returned = %d"
					   , num
					   , valid
					   , res);
	}
}
- (void)testCreditCardFormat{
	CreditCardUtil* util = [CreditCardUtil new];
	NSArray* creditCardTestNumbers = [NSArray arrayWithObjects:@"("
									 , @"5" 	
									 , @"(4"
									 , @"(45"
									 , @"(456"
									 , @"(4567"
									 , @"(45678"
									 , @"(4567) "
									 , @"(45678) 5"
									 , @"4111111111111111"
									 , nil];
	NSArray* creditCardTestNumbersFormatted = [NSArray arrayWithObjects:@""
									, @"5"
									 , @"(4"
									 , @"(45"
									 , @"(456"
									 , @"(4567) "
									 , @"(4567) 8"
									 , @"(4567"
									 , @"(4567) 85"
									 , @"(4111) 1111-1111-1111"
									 , nil];
	for (int i=0; i<[creditCardTestNumbers count]; i++) {
		NSString* num = [creditCardTestNumbers objectAtIndex:i];
		NSString* fmtNum = [creditCardTestNumbersFormatted objectAtIndex:i];
		NSString* res = [util formatCreditCardNumber:num];
		STAssertEqualObjects( res, fmtNum,@"Failed to format %@: expected = %@, returned = %@", num, fmtNum, res);
	}	
}
@end
