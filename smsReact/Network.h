//
//  Network.h
//  smsReact
//
//  Created by David 🤴 on 2023/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Network : NSObject
- (instancetype)initWithAddr:(NSString *)addr Port:(NSUInteger)port;
- (BOOL)loginWithEmail:(NSString *)email Password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
