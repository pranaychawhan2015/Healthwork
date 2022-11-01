'use strict';

const { Gateway, Wallets, HsmX509Provider, Transaction } = require('fabric-network');
const {DiscoveryService, IdentityContext, Client, Discoverer, Utils} = require('fabric-common');
const path = require('path');
const fs = require('fs');
const FabricCAServices = require('fabric-ca-client');
const { networkInterfaces, userInfo } = require('os');
const crypto = require('crypto');
const { query } = require('express');
const { channel } = require('diagnostics_channel');
const { fail } = require('assert');
const { decode } = require('querystring');
const { TextDecoder } = require('util');
const openssl = require('openssl');
const { StringDecoder } = require('string_decoder');
const Endorser = require('fabric-common');
const yaml = require('js-yaml');
const ecdsa = require('ecdsa');
var BigInteger = require('bigi');
const { json } = require('stream/consumers');
const { Query, Endorser,QueryImpl } = require('fabric-common');

//require('node-go-require');
//const cp_abe = require('')
//const openssl = require('openssl-nodejs')
//var CoinKey = require('coinkey')
// var EC = require("elliptic").ec;
// var ec = new EC("secp256k1");
//var ellipticcurve = require("starkbank-ecdsa");
//var Ecdsa = ellipticcurve.Ecdsa;
//var PrivateKey = ellipticcurve.PrivateKey;
//const eccrypto = require('eccrypto');
//const elliptic = require('elliptic');
//const { KEYUTIL } = require('jsrsasign');

async function  main(){
    try{
        const ccpPath = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org1.example.com', 'connection-org1.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        
        const ccpPath2 = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org2.example.com', 'connection-org2.json');
        const ccp2 = JSON.parse(fs.readFileSync(ccpPath2, 'utf8'));


        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
    
        // Check to see if we've already enrolled the user.
        const identity = await wallet.get('admin');
        if (!identity) {
            console.log('An identity for the user "appUser" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }
    
        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });
    
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');
        console.log(1);
        const caURL = ccp.certificateAuthorities['ca.org1.example.com'].url;
        const caInfo = ccp.certificateAuthorities['ca.org1.example.com'];
        const mspId = ccp.organizations['Org1'].mspid;
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caInfo.tlsCACerts.pem, verify: false }, caInfo.caName);

        const provider = wallet.getProviderRegistry().getProvider('X.509');
        const adminIdentity = await wallet.get('admin');
    
        const adminUser = await provider.getUserContext(adminIdentity, 'admin');
        const appUserIdentity = await wallet.get('appUser');
        console.log(3);

        const newappUser = await provider.getUserContext(appUserIdentity, 'appUser');
        const identityService = ca.newIdentityService();

        const identities = (await identityService.getAll(adminUser)).result.identities;
        identities.forEach(element => {
            console.log(element);
        });
                
        //console.log(network.getChannel('mychannel').getEndorsers()[0].name);
        //console.log(network.getChannel('mychannel').getEndorsers()[0].endpoint.creds);
        let endorsers = [];
        console.log("MSP", network.getChannel('mychannel').getMsp('peer0'))
        network.getChannel('mychannel').getEndorsers().forEach(element =>{
            if(element.name.startsWith("peer0.org1.example.com") )
            {
                endorsers.push(element);
            }
            // if(element.name.startsWith("peer0.org2.example.com")){
            //     endorsers.push(element);
            // }
        })
        const contract = network.getContract('LC_Transfer');
        let privData = {priv_peer:[ccp.peers['peer0.org1.example.com'].privateKey.pem, ccp.peers['peer1.org1.example.com'].privateKey.pem, ccp2.peers['peer0.org2.example.com'].privateKey.pem, ccp2.peers['peer1.org2.example.com'].privateKey.pem]}
        let data = Buffer.from(JSON.stringify(privData));
        //let data = ''
        let pubKey = Buffer.from(ccp.peers['peer0.org1.example.com'].signCert.pem)
        let privKey = Buffer.from(ccp.peers['peer0.org1.example.com'].privateKey.pem)
        //let data = ""
        //console.log("data" + data);
        //await contract.createTransaction('noop').setTransient({Priv_peer : data}).submit(data);
        //await contract.submitTransaction('initLedger');
        // var privateKey = sr.randomBuffer(32)
        var msg = "hello world!"
        // var ck = new CoinKey(privateKey, true)
        // var shaMsg = crypto.createHash('sha256').update(msg).digest()
        // var signature = ecdsa.sign(shaMsg, privKey)
        // var isValid = ecdsa.verify(shaMsg, signature, Buffer.from(pubKey))
        // console.log(isValid) 
        
        // const { publicKey, privateKey } = crypto.generateKeyPairSync("rsa", {
        //     // The standard secure default length for RSA keys is 2048 bits
        //     modulusLength: 2048,
        //   });

        //   const data2 = "my secret data";

        //   const encryptedData = crypto.publicEncrypt(
        //     {
        //       key: publicKey,
        //       padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
        //       oaepHash: "sha256",
        //     },
        //     // We convert the data string to a buffer using `Buffer.from`
        //     Buffer.from(data2)
        //   );
        //   console.log("encypted data: ", encryptedData.toString("base64"));

        //   const decryptedData = crypto.privateDecrypt(
        //     {
        //       key: privateKey,
        //       // In order to decrypt the data, we need to specify the
        //       // same hashing function and padding scheme that we used to
        //       // encrypt the data in the previous step
        //       padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
        //       oaepHash: "sha256",
        //     },
        //     encryptedData
        //   );
          
          // The decrypted data is of the Buffer type, which we can convert to a
          // string to reveal the original data
          //console.log("decrypted data: ", decryptedData.toString());
          //let crypto = FabricCAServices.newCryptoSuite({ software: true, keysize: 384 }); 
          console.log(1);
          //const {prvKeyHex} = KEYUTIL.getKey(appUserIdentity.credentials.privateKey)  
          console.log(2);

          //const {pubKeyHex} = KEYUTIL.getKey(appUserIdentity.credentials.certificate)
          console.log(3);

          let digest = crypto.createHash('sha256').update(msg).digest("hex")
          console.log(digest);

          //const EC = elliptic.ec;
          console.log(5);

          //const ecdsaCurve = elliptic.curves['p256'];
          console.log(6);

          //const ecdsa = new EC(ecdsaCurve);
          console.log(7);

          //const signKey = ecdsa.keyFromPrivate(prvKeyHex, 'hex');
          console.log(8);

          //const sig = ecdsa.sign(Buffer.from(digest, 'hex'), signKey);
          console.log(9);

          //const signature = Buffer.from(sig.toDER())
          //console.log(sig);

          //const veriifyKey = ecdsa.keyFromPublic(pubKeyHex, 'hex');
          //console.log(veriifyKey.getPublic().getX().toString('hex'));

          //const isverified =  ecdsa.verify(Buffer.from(digest, 'hex'), sig, veriifyKey)
          //console.log(Buffer.from(digest, 'hex'));

          //console.log(isverified)

          //let pkey = Buffer.from(JSON.stringify({pkey: private_key.toString('base64')}))
          //let message = Buffer.from(JSON.stringify({msg: digest}))
          //let signatureJSON = Buffer.from(JSON.stringify({signature : Buffer.from(signature)}))
          //let signatureJSON = Buffer.from(JSON.stringify({sigr : sig.r.toString(), sigs: sig.s.toString(), pub_x: veriifyKey.getPublic().getX().toString('hex'), pub_y: veriifyKey.getPublic().getY().toString('hex')}))
          //console.log(encryptedData.toString('base64')) 
          //await contract.submitTransaction("createPatient", "patientNumber", "Name", "Age" ,"Doctor_Specialization", "Disease", "Email", "Adhar", "Organization", data)
          //transaction.submit(
          //transaction.submit(,)
          //createPatient(ctx, patientNumber, Name, Age ,Doctor_Specialization, Disease, Email, Adhar, Organization
        //   var cp_abe1 = require('../go/cp-abe1.go');
        //   var pet = cp_abe1.pet.New('my pet');
        //   console.log(pet.Name());
        //   pet.SetName('new name...');
        //   console.log(pet.Name());
        let transaction = contract.createTransaction('getData')
        console.log(endorsers)        
        let result = await transaction.setEndorsingPeers(endorsers).evaluate('Policy');
        console.log(JSON.parse(result.toString()))
        
        const request = {
            fcn: 'getData',
            args: 'Policy',
            generateTransactionId: false
        };
        const queryProposal = network.getChannel().newQuery("LC_Transfer");
        queryProposal.build(this.identityContext, request);
        queryProposal.sign(this.identityContext);
        const query = new Query(queryProposal, this.gatewayOptions.queryHandlerOptions);
        const results = await this.queryHandler.evaluate(query);
        gateway.disconnect();  
       }
       catch(ex){
         console.log("exception: " + ex);
        }
    }
main();
