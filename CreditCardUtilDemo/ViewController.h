//
//  ViewController.h
//  CreditCardUtilDemo
//
//  Created by Shaikh Sonny Aman on 7/17/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardUtil.h"
#import "CreditCardInputUtil.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) CreditCardUtil* ccUtil;
@property (nonatomic, strong) IBOutlet UITextField* txtCC;
@property (nonatomic, strong) IBOutlet UITextField* txtExpiry;
@property (nonatomic, strong) IBOutlet UIImageView* imgCC;
@property (nonatomic, strong) IBOutlet UILabel* lblCC;

@property (nonatomic, strong) CreditCardInputUtil* ccInputUtil;
@end
