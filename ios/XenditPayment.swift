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
    
     @objc(createSingleUseToken:amount:shouldAuthenticate:onBehalfOf:resolver:rejecter:)
     func createSingleUseToken(cardParams: NSDictionary, amount: NSNumber, shouldAuthenticate: Bool, onBehalfOf: String? = nil, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
         let cardData = Mappers.mapToXenditCardData(cardData: cardParams)
         var rejected = false
         DispatchQueue.main.async {
             let rootViewController = UIApplication.shared.delegate?.window??.rootViewController ?? UIViewController()
             
             let tokenizationRequest = XenditTokenizationRequest.init(cardData: cardData, isSingleUse: true, shouldAuthenticate: true, amount: amount, currency: XenditPayment.currency)

             Xendit.createToken(fromViewController: rootViewController, tokenizationRequest: tokenizationRequest, onBehalfOf: onBehalfOf) { (token, error) in
                 if (error != nil && !rejected) {
                     rejected = true
                     // Handle error. Error is of type XenditError
                     reject(error?.errorCode, error?.message, error as? Error)
                     return
                 }
                 
                 if (token != nil) {
                     // Handle successful tokenization. Token is of type XenditCCToken
                     resolve(Mappers.mapFromXenditCCToken(token))
                 }
             }
         }
     }

    @objc(createMultipleUseToken:amount:onBehalfOf:resolver:rejecter:)
     func createMultipleUseToken(cardParams: NSDictionary, amount: NSNumber, onBehalfOf: String? = nil, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
         let cardData = Mappers.mapToXenditCardData(cardData: cardParams)
         var rejected = false
         DispatchQueue.main.async {
             let rootViewController = UIApplication.shared.delegate?.window??.rootViewController ?? UIViewController()
         
             let tokenizationRequest = XenditTokenizationRequest.init(cardData: cardData, isSingleUse: false, shouldAuthenticate: true, amount: amount, currency: XenditPayment.currency)
             
             Xendit.createToken(fromViewController: rootViewController, tokenizationRequest: tokenizationRequest, onBehalfOf: onBehalfOf) { (token, error) in
                 if (error != nil && !rejected) {
                     rejected = true
                     // Handle error. Error is of type XenditError
                     reject(error?.errorCode, error?.message, error as? Error)
                     return
                 }
                 
                 if (token != nil) {
                     // Handle successful tokenization. Token is of type XenditCCToken
                     resolve(Mappers.mapFromXenditCCToken(token))
                 }
             }
         }
     }

    @objc(createAuthentication:amount:onBehalfOf:resolver:rejecter:)
     func createAuthentication(tokenId: String, amount: NSNumber, onBehalfOf: String? = nil, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock ) -> Void {
         var rejected = false
         DispatchQueue.main.async {
             let rootViewController = UIApplication.shared.delegate?.window??.rootViewController ?? UIViewController()
         
             let authenticationRequest = XenditAuthenticationRequest.init(tokenId: tokenId, amount: amount, currency: XenditPayment.currency);
             
             Xendit.createAuthentication(fromViewController: rootViewController, authenticationRequest: authenticationRequest, onBehalfOf: onBehalfOf) { (authentication, error) in
                 if (error != nil && !rejected) {
                     rejected = true
                     // Handle error. Error is of type XenditError
                     reject(error?.errorCode, error?.message, error as? Error)
                     return
                 }
                 
                 if (authentication != nil) {
                     // Handle successful authentication. Authentication is of type XenditAuthentication
                     resolve(Mappers.mapFromXenditAuthentication(authentication))
                 }
             }
         }
     }
}
