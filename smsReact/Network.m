//
//  Network.m
//  smsReact
//
//  Created by David 🤴 on 2023/11/18.
//

#import "Network.h"

@interface Network()
@property (strong) NSString *baseAddr;
@property NSUInteger basePort;
@property (strong) NSString *userToken;
@property NSUInteger userId;
@property (strong) NSURLSession *session;
@end
@implementation Network

- (instancetype)initWithAddr:(NSString *)addr Port:(NSUInteger)port
{
    self=[super init];
    _baseAddr=addr;
    _basePort=port;
    _session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    return self;
}
- (BOOL)loginWithEmail:(NSString *)email Password:(NSString *)password{
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/account/login",_baseAddr]]];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:email, @"email", password, @"passwprd", nil];
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingSortedKeys error:nil];
    [_session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            <#statements#>
        } else {
            NSLog(@"%@",error);
        }
    }];
}
@end
