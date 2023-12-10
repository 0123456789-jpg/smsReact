//
//  Network.h
//  smsReact
//
//  Created by David 🤴 on 2023/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSNetwork : NSObject <NSURLSessionTaskDelegate>

- (instancetype)initWithAddr:(NSString *)addr Port:(NSUInteger)port;
- (void)loginWithEmail:(NSString *)email Password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
