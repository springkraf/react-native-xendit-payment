import Foundation
import UIKit
import AVFoundation
import Xendit

@objc(XenditPayment)
class XenditPayment: NSObject {
    // Publishable key
    private static var publishableKey: String?
    private static let currency: String = "IDR"
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return false
    }

    @objc(initialize:)
     func initialize(publicKey: String) -> Void {
         Xendit.publishableKey = publicKey
     }
    
     @objc(createSingleUseToken:amount:shouldAuthenticate:onBehalfOf:withResolver:withRejecter:)
     func createSingleUseToken(cardParams: NSDictionary, amount: NSNumber, shouldAuthenticate: Bool, onBehalfOf: String? = nil, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
         let cardData = Mappers.mapToXenditCardData(cardData: cardParams)
         DispatchQueue.main.async {
             let rootViewController = UIApplication.shared.delegate?.window??.rootViewController ?? UIViewController()
             
             let tokenizationRequest = XenditTokenizationRequest.init(cardData: cardData, isSingleUse: true, shouldAuthenticate: true, amount: amount, currency: XenditPayment.currency)

             Xendit.createToken(fromViewController: rootViewController, tokenizationRequest: tokenizationRequest, onBehalfOf: onBehalfOf) { (token, error) in
                 if (error != nil) {
                     // Handle error. Error is of type XenditError
                     reject(error?.errorCode, error?.message, error as? Error)
                     return
                 }

                 // Handle successful tokenization. Token is of type XenditCCToken
                 resolve(Mappers.mapFromXenditCCToken(token))
             }
         }
     }

    @objc(createMultipleUseToken:amount:onBehalfOf:withResolver:withRejecter:)
     func createMultipleUseToken(cardParams: NSDictionary, amount: NSNumber, onBehalfOf: String? = nil, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
         let cardData = Mappers.mapToXenditCardData(cardData: cardParams)
         DispatchQueue.main.async {
             let rootViewController = UIApplication.shared.delegate?.window??.rootViewController ?? UIViewController()
         
             let tokenizationRequest = XenditTokenizationRequest.init(cardData: cardData, isSingleUse: false, shouldAuthenticate: true, amount: amount, currency: XenditPayment.currency)
             
             Xendit.createToken(fromViewController: rootViewController, tokenizationRequest: tokenizationRequest, onBehalfOf: onBehalfOf) { (token, error) in
                 if (error != nil) {
                     // Handle error. Error is of type XenditError
                     reject(error?.errorCode, error?.message, error as? Error)
                     return
                 }

                 // Handle successful tokenization. Token is of type XenditCCToken
                 resolve(Mappers.mapFromXenditCCToken(token))
             }
         }
     }

    @objc(createAuthentication:amount:onBehalfOf:withResolver:withRejecter:)
     func createAuthentication(tokenId: String, amount: NSNumber, onBehalfOf: String? = nil, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock ) -> Void {
//         let cardData = Mappers.mapToXenditCardData(cardData: cardParams)
         DispatchQueue.main.async {
             let rootViewController = UIApplication.shared.delegate?.window??.rootViewController ?? UIViewController()
         
             let authenticationRequest = XenditAuthenticationRequest.init(tokenId: tokenId, amount: amount, currency: XenditPayment.currency);
//             authenticationRequest.cardCvn = cardData.cardCvn;
             
             Xendit.createAuthentication(fromViewController: rootViewController, authenticationRequest: authenticationRequest, onBehalfOf: onBehalfOf) { (authentication, error) in
                     if (error != nil) {
                          // Handle error. Error is of type XenditError
                          reject(error?.errorCode, error?.message, error as? Error)
                          return
                      }

                      // Handle successful authentication. Authentication is of type XenditAuthentication
                     resolve(Mappers.mapFromXenditAuthentication(authentication))
                  }
         }
     }
}
