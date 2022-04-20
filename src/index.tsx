import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-xendit-payment' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const XenditPayment = NativeModules.XenditPayment
  ? NativeModules.XenditPayment
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export interface CardMetadata {
  bank: string;
  country: string;
  type: string;
  brand: string;
  cardArtUrl: string;
  fingerprint: string;
}

export interface Card {
  creditCardNumber: string;
  cardExpirationMonth: string;
  cardExpirationYear: string;
  creditCardCVN: string;
}

export interface Token {
  id: string;
  status: string;
  authenticationId: string;
  authenticationURL?: string;
  maskedCardNumber: string;
  should3DS: boolean;
  cardInfo: CardMetadata;
  failureReason?: string;
}

export interface Authentication {
  id: string;
  status: string;
  tokenId?: string;
  authenticationURL?: string;
  authenticationTransactionId?: string;
  requestPayload?: string;
  maskedCardNumber?: string;
  cardInfo: CardMetadata;
  threedsVersion?: string;
  failureReason?: string;
}

export function init(publicKey: string) {
  XenditPayment.initialize(publicKey);
}

export function createSingleUseToken(
  card: Card,
  amount: number,
  shouldAuthenticate: boolean = true,
  onBehalfOf?: string
): Token {
  return XenditPayment.createSingleUseToken(
    card,
    amount,
    shouldAuthenticate,
    onBehalfOf
  );
}

export function createMultipleUseToken(
  card: Card,
  amount: number,
  onBehalfOf?: string
): Token {
  return XenditPayment.createMultipleUseToken(card, amount, onBehalfOf);
}

export function createAuthentication(
  tokenId: string,
  amount: number,
  onBehalfOf?: string
): Authentication {
  return XenditPayment.createAuthentication(tokenId, amount, onBehalfOf);
}
