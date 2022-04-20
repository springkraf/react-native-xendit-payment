package com.reactnativexenditpayment

import com.facebook.react.bridge.*
import com.xendit.AuthenticationCallback
import com.xendit.Models.*
import com.xendit.TokenCallback
import com.xendit.Xendit

class XenditPaymentModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    private var xendit: Xendit? = null;

    override fun getName(): String {
        return "XenditPayment"
    }

    @ReactMethod
    fun initialize(publicKey: String) {
      xendit = Xendit(reactApplicationContext, publicKey, currentActivity);
    }

    @ReactMethod
    fun createSingleUseToken(cardParams: ReadableMap, amount: Double, shouldAuthenticate: Boolean, onBehalfOf: String?, promise: Promise) {
      val card = mapToCard(cardParams)

      xendit?.createSingleUseToken(card, amount.toInt(), shouldAuthenticate, onBehalfOf, object : TokenCallback() {
        override fun onSuccess(token: Token?) {
          promise.resolve(mapFromToken(token))
        }

        override fun onError(error: XenditError?) {
          promise.reject(error?.errorCode, error?.errorMessage)
        }
      })
    }

    @ReactMethod
    fun createMultipleUseToken(cardParams: ReadableMap, amount: Double, onBehalfOf: String?, promise: Promise) {
      val card = mapToCard(cardParams)

      xendit?.createMultipleUseToken(card, onBehalfOf, object : TokenCallback() {
        override fun onSuccess(token: Token?) {
          promise.resolve(mapFromToken(token))
        }

        override fun onError(error: XenditError?) {
          promise.reject(error?.errorCode, error?.errorMessage)
        }
      })
    }

    @ReactMethod
    fun createAuthentication(tokenId: String, amount: Double, onBehalfOf: String?, promise: Promise) {
      xendit?.createAuthentication(tokenId, amount.toInt(), onBehalfOf, object : AuthenticationCallback() {
        override fun onSuccess(authentication: Authentication?) {
          promise.resolve(mapFromAuthentication(authentication))
        }

        override fun onError(error: XenditError?) {
          promise.reject(error?.errorCode, error?.errorMessage)
        }
      })
    }
}
