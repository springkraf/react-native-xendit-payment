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
     func createSingleUseToken(cardParams: NSDictionary, amount: NSNumber, shouldAuthenticate: Bool, onBehalfOf: String? = nil, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
         let cardData = createCard(params: cardParams)
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
                 resolve(token?.id)
             }
         }
     }

    @objc(createMultipleUseToken:amount:onBehalfOf:withResolver:withRejecter:)
     func createMultipleUseToken(cardParams: NSDictionary, amount: NSNumber, onBehalfOf: String? = nil, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock ) {
         let cardData = createCard(params: cardParams)
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
                 resolve(token?.id)
             }
         }
     }

    @objc(createAuthentication:tokenId:amount:onBehalfOf:withResolver:withRejecter:)
     func createAuthentication(cardParams: NSDictionary, tokenId: String, amount: NSNumber, onBehalfOf: String? = nil, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock ) {
         let cardData = createCard(params: cardParams)
         DispatchQueue.main.async {
             let rootViewController = UIApplication.shared.delegate?.window??.rootViewController ?? UIViewController()
         
             let authenticationRequest = XenditAuthenticationRequest.init(tokenId: tokenId, amount: amount, currency: XenditPayment.currency);
             authenticationRequest.cardCvn = cardData.cardCvn;
             
             Xendit.createAuthentication(fromViewController: rootViewController, authenticationRequest: authenticationRequest, onBehalfOf: onBehalfOf) { (authentication, error) in
                      if (error != nil) {
                          // Handle error. Error is of type XenditError
                          reject(error?.errorCode, error?.message, error as? Error)
                          return
                      }

                      // Handle successful authentication
                      resolve(authentication?.id)
                  }
         }
     }
    
    @objc
    func createCard(params: NSDictionary) -> XenditCardData {
         let creditCardNumber: String = params["creditCardNumber"] as! String
         let cardExpirationMonth: String = params["cardExpirationMonth"] as! String
         let cardExpirationYear: String = params["cardExpirationYear"] as! String
         let creditCardCVN: String = params["creditCardCVN"] as! String
        
         let cardData = XenditCardData(cardNumber: creditCardNumber, cardExpMonth: cardExpirationMonth, cardExpYear: cardExpirationYear)
         cardData.cardCvn = creditCardCVN
         
         return cardData
     }
}
