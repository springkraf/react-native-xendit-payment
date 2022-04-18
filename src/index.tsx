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

export interface Card {
  creditCardNumber: string;
  cardExpirationMonth: string;
  cardExpirationYear: string;
  creditCardCVN: string;
}

export function init(publicKey: string) {
  XenditPayment.initialize(publicKey);
}

export function createSingleUseToken(
  card: Card,
  amount: number,
  shouldAuthenticate: boolean = true,
  onBehalfOf?: string
): string {
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
): string {
  return XenditPayment.createMultipleUseToken(card, amount, onBehalfOf);
}

export function createAuthentication(
  card: Card,
  tokenId: string,
  amount: number,
  onBehalfOf?: string
): string {
  return XenditPayment.createAuthentication(card, tokenId, amount, onBehalfOf);
}
