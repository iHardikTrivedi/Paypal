//
//  ViewController.m
//  PaypalDemo
//
//  Created by Hardik Trivedi on 13/09/2015.
//  Copyright (c) 2015 iHartDevelopers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentSandbox

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tvPaymentDetail setText:@"Your Transaction Details are Empty . . ."];
    
    [self configurePayPal];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success! : %@", completedPayment.confirmation);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pay Successfully"
                                                    message:[NSString stringWithFormat:@"Your have paid successfully with transection id : %@ .", [[completedPayment.confirmation valueForKey:@"response"] valueForKey:@"id"]]
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [self.tvPaymentDetail setText:[NSString stringWithFormat:@"%@", completedPayment.confirmation]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    [self.tvPaymentDetail setText:@"Your Transaction Details are Empty . . ."];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBAction Methods

- (IBAction)btnPayNowTapped:(id)sender
{
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"iOS Application Development"
                                    withQuantity:2
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    PayPalItem *item2 = [PayPalItem itemWithName:@"Free Testing"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00066"];
    PayPalItem *item3 = [PayPalItem itemWithName:@"Android Application Development"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00291"];
    NSArray *items = @[item1, item2, item3];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"This is multi technology developing firm.";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - Other Methods

- (void)configurePayPal
{
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"iHart Developers";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // use default environment, should be Production in real life
    [PayPalMobile preconnectWithEnvironment:kPayPalEnvironment];
}

@end
