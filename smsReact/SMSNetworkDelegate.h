//
//  SMSNetworkDelegate.h
//  smsReact
//
//  Created by David 🤴 on 2023/12/11.
//

#import "SMSNetwork.h"
#import <Foundation/Foundation.h>

@protocol SMSNetworkDelegate

@required
- (void)network:(SMSNetwork *)network didLoginWithError:(NSError *)error;
- (void)network:(SMSNetwork *)network didLogoutWithError:(NSError *)error;

@optional

@end