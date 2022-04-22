#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(XenditPayment, RCTEventEmitter)

RCT_EXTERN_METHOD(initialize:(NSString *)publicKey)

RCT_EXTERN_METHOD(createSingleUseToken:(NSDictionary *)card amount:(nonnull NSNumber *)amount shouldAuthenticate:(NSNumber *)shouldAuthenticate onBehalfOf:(NSString *)onBehalfOf resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(createMultipleUseToken:(NSDictionary *)card amount:(nonnull NSNumber *)amount onBehalfOf:(NSString *)onBehalfOf resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(createAuthentication:(NSString *)tokenId amount:(nonnull NSNumber *)amount onBehalfOf:(NSString *)onBehalfOf resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

@end
