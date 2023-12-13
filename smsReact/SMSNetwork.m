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

@property(strong) NSURL *baseAddr;
@property(strong) NSString *userToken;
@property NSUInteger userId;
@property(strong) NSURLSession *session;
@property(nonatomic, weak) id<SMSNetworkDelegate> delegate;

typedef NS_ENUM(NSUInteger, SMSNetworkTaskType) {
  // Default value of [aString intValue] when parsing error.
  SMSNetworkTaskUnknown = 0,
  SMSNetworkTaskLogin = 1,
  SMSNetworkTaskLogout = 2,
};

@end

@implementation SMSNetwork

- (instancetype)initWithAddr:(NSString *)addr
                        port:(NSUInteger)port
                    delegate:(id<SMSNetworkDelegate>)delegate {
  self = [super init];
  _baseAddr = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%lu",addr,port]];
  _session = [NSURLSession
      sessionWithConfiguration:[NSURLSessionConfiguration
                                   ephemeralSessionConfiguration]];
  _delegate = delegate;
  return self;
}

- (void)loginWithEmail:(NSString *)email Password:(NSString *)password {
  NSMutableURLRequest *request = [NSMutableURLRequest
      requestWithURL:[NSURL URLWithString:@"/api/account/login" relativeToURL:_baseAddr]];
  request.HTTPMethod = @"POST";
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  NSDictionary *dict = [NSDictionary
      dictionaryWithObjectsAndKeys:email, @"email", password, @"password", nil];
  NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                 options:0
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
                                                    options:0
                                                      error:nil];
                  self->_userId =
                    [(NSNumber *)(body[@"account_id"]) unsignedIntegerValue];
                  self->_userToken = (NSString *)(body[@"token"]);
                // Error unfinished
                  [self->_delegate network:self didLoginWithError:nil];
              } else {
                // TODO: Handle server error
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

- (void)logout{
    if (!_userToken||!_userId) {
        // TODO: Need to implement error
        [_delegate network:self didLogoutWithError:<#(NSError *)#>]
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"/api/account/logout" relativeToURL:_baseAddr]];
    request.HTTPMethod=@"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%lu", _userId] forHTTPHeaderField:@"AccountId"];
    [request addValue:_userToken forHTTPHeaderField:@"Token"];
    NSURLSessionUploadTask *task = [_session uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode>=200||statusCode<=299){
                self->_userToken=nil;
                self->_userId=0;
                [self->_delegate network:self didLogoutWithError:nil];
            }else{
                // TODO: Handle server error
            }
        }else{
            // TODO: Handle client error
        }
    }];
    task.taskDescription=[NSString stringWithFormat:@"%lu",(NSUInteger)SMSNetworkTaskLogout];
    [task resume];
}

@end
