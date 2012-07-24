//
//  ViewController.m
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/17/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imgCC, txtCC, txtExpiry, lblCC, ccUtil, ccInputUtil;
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.ccInputUtil = [[CreditCardInputUtil alloc] initWithCardNumberField:txtCC 
															expiryDateField:txtExpiry 
														  cardEntryCallback:^(CreditCardInfo* card){
															  if (card){
																  imgCC.image = card.issuingNetwork.icon;
																  lblCC.text = card.issuingNetwork.networkName;
															  }	else {
																  lblCC.text = @"Not a valid card number";
																  imgCC.image = nil;
															  }		  
														  } 
														  dateEntryCallback:^(int month, int year, BOOL isValid, BOOL isDone, CreditCardInfo* card){
															  if (isDone && !isValid) {
																  lblCC.text = @"Not a valid date!";
															  }
															  
															  if (isDone && isValid && !card.isAccepted) {
																  lblCC.text = @"Card is not accepted!";
															  }
														  }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.imgCC = nil;
	self.txtCC = nil;
	self.txtExpiry = nil;
	self.lblCC = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - CreditCardUtilDelegate
//- (void)onCreditCardTypeChanged:(CCType)type{
////	lblCC.text = [CreditCardUtil getCreditCardNameFromType:type];
//	//imgCC.image = [CreditCardUtil getCreditCardIcon:type];
//}
- (void)onCreditCardExpiryDateEntered:(NSString*)date{
	NSLog(@"Expiry date= %@", date);
}
- (void)onCreditCardNumberEntered:(NSString*) number{
	NSLog(@"Credit card = %@", number);
}
@end
