//
//  SMSNetwork.m
//  smsReact
//
//  Created by David 🤴 on 2023/11/18.
//

#import "SMSNetwork.h"
#import "SMSNetworkDelegate.h"
#import <Foundation/Foundation.h>

@interface SMSNetwork ()

@property(strong) NSString *baseAddr;
@property NSUInteger basePort;
@property(strong) NSString *userToken;
@property NSUInteger userId;
@property(strong) NSURLSession *session;
@property(nonatomic, weak) id<SMSNetworkDelegate> delegate;

typedef NS_ENUM(NSUInteger, SMSNetworkTaskType) {
  // Default value of [aString intValue] when parsing error.
  SMSNetworkTaskUnknown = 0,
  SMSNetworkTaskLogin = 1,
};

@end

@implementation SMSNetwork

- (instancetype)initWithAddr:(NSString *)addr
                        port:(NSUInteger)port
                    delegate:(id<SMSNetworkDelegate>)delegate {
  self = [super init];
  _baseAddr = addr;
  _basePort = port;
  _session = [NSURLSession
      sessionWithConfiguration:[NSURLSessionConfiguration
                                   ephemeralSessionConfiguration]];
  _delegate = delegate;
  return self;
}

- (void)loginWithEmail:(NSString *)email Password:(NSString *)password {
  NSMutableURLRequest *request = [NSMutableURLRequest
      requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:
                                                        @"%@/api/account/login",
                                                        _baseAddr]]];
  request.HTTPMethod = @"POST";
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  NSDictionary *dict = [NSDictionary
      dictionaryWithObjectsAndKeys:email, @"email", password, @"password", nil];
  NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                 options:nil
                                                   error:nil];
  NSURLSessionUploadTask *task = [_session
      uploadTaskWithRequest:request
                   fromData:data
          completionHandler:^(NSData *_Nullable data,
                              NSURLResponse *_Nullable response,
                              NSError *_Nullable error) {
            if (!error) {
              NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
              if (statusCode >= 200 && statusCode <= 299) {
                NSDictionary *body =
                    [NSJSONSerialization JSONObjectWithData:data
                                                    options:nil
                                                      error:nil];
                _userId =
                    [(NSNumber *)(body[@"account_id"]) unsignedIntegerValue];
                _userToken = (NSString *)(body[@"token"]);
                // Error unfinished
                [_delegate network:self didLoginWithError:nil];
              } else {
                // [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
              }
            } else {
              // TODO: Handle client error
            }
          }];
  task.taskDescription =
      [NSString stringWithFormat:@"%lu", (NSUInteger)SMSNetworkTaskLogin];
  [task resume];
}

@end
