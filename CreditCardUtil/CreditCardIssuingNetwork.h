//
//  CreditCard.h
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/18/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreditCardInfo.h"

typedef BOOL(^t_CreditCardValidAlgorithm)(NSString*);

/**
 * This class reflects a issuing network. Used in CreditCardUtil calss.
 */
@interface CreditCardIssuingNetwork : NSObject

@property (nonatomic, strong) NSString* networkName;
@property (nonatomic, strong) NSString* errorMessage;

@property (nonatomic, strong) NSDictionary* numberFormats;
@property (nonatomic, strong) NSString* dateFormat;

@property (nonatomic, strong) NSMutableArray* validLengths;
@property (nonatomic, strong) NSMutableArray* prefixes;
@property (nonatomic, strong) UIImage* icon;
@property (nonatomic, strong) t_CreditCardValidAlgorithm validtionAlgorithm;

- (id) initWithName:(NSString*)name prefixes:(NSString*)prefixAndranges validCardLengths:(NSString*)lengths icon:(UIImage*)icon validationAlgorithm:(t_CreditCardValidAlgorithm)algorithmOrNil;
- (CreditCardInfo*) createCardWithNumber:(NSString*) cardNumber;

@end
