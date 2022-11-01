'use strict';

const { Gateway, Wallets, HsmX509Provider, Transaction } = require('fabric-network');
const {DiscoveryService, IdentityContext, Client, Discoverer, Utils} = require('fabric-common');
const path = require('path');
const fs = require('fs');
const FabricCAServices = require('fabric-ca-client');
const { TransactionEventHandler } = require('fabric-network/lib/impl/event/transactioneventhandler');

const { networkInterfaces } = require('os');
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
//require('node-go-require');


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

        const newappUser = await provider.getUserContext(appUserIdentity, 'appUser');        const identityService = ca.newIdentityService();
                
        let endorsers = [];
		let mychannel = network.getChannel('mychannel')
        // mychannel.getEndorsers().map(async(element) => {
        //     console.log(element.name)
        //     if(element.name.startsWith("peer0.org1.example.com") )
        //     {
        //         endorsers.push(element);
        //     }
        //     if(element.name.startsWith("peer0.org2.example.com")){
        //         endorsers.push(element);
        //     }
        // })
        let contract = network.getContract('LCTransfer7')
        // response contains an array of collection definitions
        let transaction = contract.createTransaction('putPrivateAsset');
        //let endorsersArray = []
        //endorsersArray.push(element)
        let newObject = {name: "This is good"}
        let result = await transaction.submit("Robot1234", 'collections', JSON.stringify(newObject))
        if (result != null || result != ""){
            console.log("testing", result.toString())
        }

        let result2 = await contract.submitTransaction("getPrivateAsset","Robot1234", "collections")
        const strValue = result2.toJSON();
        //var str = JSON.parse(Buffer.from(result2.buffer).toString('utf8'))  
        var str = Buffer.from(result2).toString('utf8')
        console.log(JSON.parse(str).name)

        gateway.disconnect();
       }
       catch(ex){
         console.log("exception: " + ex);
        }
    }
main();
