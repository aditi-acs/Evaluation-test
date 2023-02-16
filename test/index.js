const bip39 = require('bip39');
const { hdkey } = require('ethereumjs-wallet');

// Generating random mnemonic phrase
const mnemonic = bip39.generateMnemonic();
console.log({mnemonic})

// Deriving the HD wallet from the mnemonic phrase and path
const hdwallet = hdkey.fromMasterSeed(bip39.mnemonicToSeedSync(mnemonic));
console.log(hdwallet)

// Using Ethereum wallet path to get wallet address
const path = "m/44'/60'/0'/0/0"; // change the last number for a different address
const wallet = hdwallet.derivePath(path).getWallet();

// Converting derived address to a string
const address = '0x' + wallet.getAddress().toString('hex');

// Printing the results
console.log('Mnemonic phrase: ' + mnemonic);
console.log('Address: ' + address);


