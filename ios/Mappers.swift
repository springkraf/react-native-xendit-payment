//
//  Mappers.swift
//  XenditPayment
//
//  Created by Ritchie Goldwin on 20/04/22.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation
import Xendit

class Mappers {
    class func createResult(_ key: String, _ value: NSDictionary?) -> NSDictionary {
        return [key: value ?? NSNull()]
    }
    
    class func mapToXenditCardData(cardData: NSDictionary) -> XenditCardData {
        let creditCardNumber: String = cardData["creditCardNumber"] as! String
        let cardExpirationMonth: String = cardData["cardExpirationMonth"] as! String
        let cardExpirationYear: String = cardData["cardExpirationYear"] as! String
        let creditCardCVN: String = cardData["creditCardCVN"] as! String
       
        let xenditCardData = XenditCardData(cardNumber: creditCardNumber, cardExpMonth: cardExpirationMonth, cardExpYear: cardExpirationYear)
        xenditCardData.cardCvn = creditCardCVN
        
        return xenditCardData
    }
    
    class func mapFromXenditCardMetadata(_ cardMetadata: XenditCardMetadata?) -> NSDictionary? {
        if (cardMetadata == nil) {
            return nil
        }
        let cardMetadataMap: NSDictionary = [
            "bank": cardMetadata?.bank ?? NSNull(),
            "country": cardMetadata?.country ?? NSNull(),
            "type": cardMetadata?.type ?? NSNull(),
            "brand": cardMetadata?.brand ?? NSNull(),
            "cardArtUrl": cardMetadata?.cardArtUrl ?? NSNull(),
            "fingerprint": cardMetadata?.fingerprint ?? NSNull(),
        ]
        return cardMetadataMap
    }
    
    class func mapFromXenditCCToken(_ token: XenditCCToken?) -> NSDictionary? {
        if (token == nil) {
            return nil
        }
        let tokenMap: NSDictionary = [
            "id": token?.id ?? NSNull(),
            "status": token?.status ?? NSNull(),
            "authenticationId": token?.authenticationId ?? NSNull(),
            "authenticationURL": token?.authenticationURL ?? NSNull(),
            "maskedCardNumber": token?.maskedCardNumber ?? NSNull(),
            "should3DS": token?.should3DS ?? NSNull(),
            "cardInfo": mapFromXenditCardMetadata(token?.cardInfo) ?? NSNull(),
            "failureReason": token?.failureReason ?? NSNull(),
        ]
        return tokenMap
    }
    
    class func mapFromXenditAuthentication(_ authentication: XenditAuthentication?) -> NSDictionary? {
        if (authentication == nil) {
            return nil
        }
        let authenticationMap: NSDictionary = [
            "id": authentication?.id ?? NSNull(),
            "status": authentication?.status ?? NSNull(),
            "tokenId": authentication?.tokenId ?? NSNull(),
            "authenticationURL": authentication?.authenticationURL ?? NSNull(),
            "authenticationTransactionId": authentication?.authenticationTransactionId ?? NSNull(),
            "requestPayload": authentication?.requestPayload ?? NSNull(),
            "maskedCardNumber": authentication?.maskedCardNumber ?? NSNull(),
            "cardInfo": mapFromXenditCardMetadata(authentication?.cardInfo) ?? NSNull(),
            "threedsVersion": authentication?.threedsVersion ?? NSNull(),
            "failureReason": authentication?.failureReason ?? NSNull(),
        ]
        return authenticationMap
    }
}
