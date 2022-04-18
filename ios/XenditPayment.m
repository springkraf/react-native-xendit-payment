#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(XenditPayment, NSObject)

RCT_EXTERN_METHOD(initialize:(NSString *)publicKey)

RCT_EXTERN_METHOD(createSingleUseToken:(NSDictionary *)card amount:(nonnull NSNumber *)amount shouldAuthenticate:(NSNumber *)shouldAuthenticate onBehalfOf:(NSString *)onBehalfOf withResolver:(RCTPromiseResolveBlock)resolve withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(createMultipleUseToken:(NSDictionary *)card amount:(nonnull NSNumber *)amount onBehalfOf:(NSString *)onBehalfOf withResolver:(RCTPromiseResolveBlock)resolve withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(createAuthentication:(NSDictionary *)card tokenId:(NSString *)tokenId amount:(nonnull NSNumber *)amount onBehalfOf:(NSString *)onBehalfOf withResolver:(RCTPromiseResolveBlock)resolve withRejecter:(RCTPromiseRejectBlock)reject)

@end
