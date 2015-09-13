//
//  ViewController.h
//  PaypalDemo
//
//  Created by Hardik Trivedi on 13/09/2015.
//  Copyright (c) 2015 iHartDevelopers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface ViewController : UIViewController <PayPalPaymentDelegate>

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@property (weak, nonatomic) IBOutlet UITextView *tvPaymentDetail;

@end

