//
//  SMSNetwork.h
//  smsReact
//
//  Created by David 🤴 on 2023/11/18.
//

#import "SMSNetworkDelegate.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSNetwork : NSObject <NSURLSessionTaskDelegate>

- (instancetype)initWithAddr:(NSString *)addr
                        port:(NSUInteger)port
                    delegate:(id<SMSNetworkDelegate>)delegate;
- (void)loginWithEmail:(NSString *)email Password:(NSString *)password;
- (void)logout;

@end

NS_ASSUME_NONNULL_END
