//
//  SMSNetworkDelegate.h
//  smsReact
//
//  Created by David 🤴 on 2023/12/11.
//

#import <Foundation/Foundation.h>

@class SMSNetwork;

@protocol SMSNetworkDelegate

@required
// Login is successful if `error` is `nil`.
- (void)network:(SMSNetwork *)network didLoginWithError:(NSError *)error;
- (void)network:(SMSNetwork *)network didLogoutWithError:(NSError *)error;

@optional

@end