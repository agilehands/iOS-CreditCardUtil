//
//  CreditCardUtilTest.m
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/18/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import "CreditCardUtilTest.h"
#import "CreditCardUtil.h"

@implementation CreditCardUtilTest
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
	NSArray* creditCardTestNumbers = [NSArray arrayWithObjects:@"3782822463100000"
									  , @"371449635398431"
									  , @"30569309025904"
									  , @"38520000023237"
									  , @"6011111111111117"
									  , @"6011000990139424"
									  , @"5555555555554444"
									  , @"5105105105105100"
									  , @"4111111111111111"
									  , @"4222222222222"
									  , @"3530111333300000"
									  , nil];
	
	CreditCardUtil* ccUtil = [[CreditCardUtil alloc] init];
	for (NSString* number in creditCardTestNumbers) {
		NSLog(@"Testing: %@",number);
		CreditCardInfo* card =  [ccUtil getCreditCardInfo:number];
		if (card) {
			NSLog(@"Found:\n %@\n\n\n", card);
		} else {
			NSLog(@"NOT found \n\n\n");
		}		
	}		
}
@end
