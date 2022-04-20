package com.reactnativexenditpayment

import com.facebook.react.bridge.*
import com.xendit.Models.*

internal fun createResult(key: String, value: WritableMap): WritableMap {
  val map = WritableNativeMap()
  map.putMap(key, value)
  return map
}

internal fun mapToCard(card: ReadableMap): Card {
  val creditCardNumber = card.getString("creditCardNumber")
  val cardExpirationMonth = card.getString("cardExpirationMonth")
  val cardExpirationYear = card.getString("cardExpirationYear")
  val creditCardCVN = card.getString("creditCardCVN")

  return Card(creditCardNumber, cardExpirationMonth, cardExpirationYear, creditCardCVN)
}

internal fun mapFromCardInfo(cardInfo: CardInfo?): WritableMap? {
  val cardInfoMap: WritableMap = WritableNativeMap()

  if (cardInfo == null) {
    return null
  }

  cardInfoMap.putString("bank", cardInfo.bank)
  cardInfoMap.putString("country", cardInfo.country)
  cardInfoMap.putString("type", cardInfo.type)
  cardInfoMap.putString("brand", cardInfo.brand)
  cardInfoMap.putString("cardArtUrl", cardInfo.cardArtUrl)
  cardInfoMap.putString("fingerprint", cardInfo.fingerprint)

  return cardInfoMap
}

internal fun mapFromToken(token: Token?): WritableMap? {
  val tokenMap: WritableMap = WritableNativeMap()

  if (token == null) {
    return null
  }

  tokenMap.putString("id", token.id)
  tokenMap.putString("status", token.status)
  tokenMap.putString("authenticationId", token.authenticationId)
  tokenMap.putString("maskedCardNumber", token.maskedCardNumber)
  tokenMap.putBoolean("should3DS", token.should_3DS)
  tokenMap.putMap("cardInfo", mapFromCardInfo(token.cardInfo))

  return tokenMap
}

internal fun mapFromAuthentication(authentication: Authentication?): WritableMap? {
  val authenticationMap: WritableMap = WritableNativeMap()

  if (authentication == null) {
    return null
  }

  authenticationMap.putString("id", authentication.id)
  authenticationMap.putString("status", authentication.status)
  authenticationMap.putString("tokenId", authentication.creditCardTokenId)
  authenticationMap.putString("authenticationURL", authentication.payerAuthenticationUrl)
  authenticationMap.putString("authenticationTransactionId", authentication.authenticationTransactionId)
  authenticationMap.putString("requestPayload", authentication.requestPayload)
  authenticationMap.putString("maskedCardNumber", authentication.maskedCardNumber)
  authenticationMap.putMap("cardInfo", mapFromCardInfo(authentication.cardInfo))

  return authenticationMap
}
