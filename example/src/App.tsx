import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import {
  init,
  createSingleUseToken,
  createMultipleUseToken,
  createAuthentication,
} from 'react-native-xendit-payment';

export default function App() {
  const [result, setResult] = React.useState<number | string>();

  React.useEffect(() => {
    init(
      'xnd_public_development_0LgUKtsj2SPxM0qesjDfrHkFBepv8ELJaRObBFlbymptTiumeWVsfSSIFaago'
    );
  }, []);

  const createSingleToken = async () => {
    try {
      const card = {
        creditCardNumber: '4000000000000002',
        // creditCardNumber: '4000000000000044',
        cardExpirationMonth: '12',
        cardExpirationYear: '2022',
        creditCardCVN: '123',
      };
      const token = await createSingleUseToken(card, 200000);
      console.log('TOKEN', token);
      setResult(token.id);
    } catch (e: any) {
      console.log('ERROR', e.message);
    }
  };

  const createMultipleToken = async () => {
    try {
      const card = {
        creditCardNumber: '4000000000000002',
        cardExpirationMonth: '12',
        cardExpirationYear: '2022',
        creditCardCVN: '123',
      };
      const token = await createMultipleUseToken(card, 200000);
      setResult(token.id);
      console.log('TOKEN', token);
    } catch (e: any) {
      console.log('ERROR', e.message);
    }
  };

  const authenticate = async () => {
    try {
      const auth = await createAuthentication(result!.toString(), 200000);
      console.log('AUTH', auth);
    } catch (e: any) {
      console.log('ERROR', e.message);
    }
  };

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Button title="Single Token" onPress={createSingleToken} />
      <Button title="Multiple Token" onPress={createMultipleToken} />
      <Button title="Authentication" onPress={authenticate} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
