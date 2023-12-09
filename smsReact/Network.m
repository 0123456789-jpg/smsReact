//
//  Network.m
//  smsReact
//
//  Created by David 🤴 on 2023/11/18.
//

#import "Network.h"
#include <Foundation/Foundation.h>

@interface Network ()

@property(strong) NSString *baseAddr;
@property NSUInteger basePort;
@property(strong) NSString *userToken;
@property NSUInteger userId;
@property(strong) NSURLSession *session;

enum TaskType{
  LOGIN=0,
};

@end

@implementation Network

- (instancetype)initWithAddr:(NSString *)addr Port:(NSUInteger)port {
  self = [super init];
  _baseAddr = addr;
  _basePort = port;
  _session = [NSURLSession
      sessionWithConfiguration:[NSURLSessionConfiguration
                                   ephemeralSessionConfiguration]];
  return self;
}

- (void)loginWithEmail:(NSString *)email Password:(NSString *)password {
  NSMutableURLRequest *request = [NSMutableURLRequest
      requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:
                                                        @"%@/api/account/login",
                                                        _baseAddr]]];
  NSDictionary *dict = [NSDictionary
      dictionaryWithObjectsAndKeys:email, @"email", password, @"password", nil];
  NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                 options:nil
                                                   error:nil];
  NSURLSessionUploadTask *task = [_session uploadTaskWithRequest:request
                                                        fromData:data];
  task.taskDescription = @"login";
  [task resume];
}

- (void)URLSession:(NSURLSession *)session
                    task:(NSURLSessionTask *)task
    didCompleteWithError:(NSError *)error {
  if ([session isEqualTo:_session]) {
    switch ([task.taskDescription intValue]) {}
  }
}

@end
