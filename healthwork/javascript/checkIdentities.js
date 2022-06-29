'use strict';

const { Gateway, Wallets, HsmX509Provider, Transaction } = require('fabric-network');
const {DiscoveryService, IdentityContext, Client, Discoverer} = require('fabric-common');
const path = require('path');
const fs = require('fs');
const FabricCAServices = require('fabric-ca-client');
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

async function  main(){
    try{
        const ccpPath = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org2.example.com', 'connection-org2.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        
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
        const caURL = ccp.certificateAuthorities['ca.org2.example.com'].url;
        const caInfo = ccp.certificateAuthorities['ca.org2.example.com'];
        const mspId = ccp.organizations['Org2'].mspid;
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caInfo.tlsCACerts.pem, verify: false }, caInfo.caName);

        const provider = wallet.getProviderRegistry().getProvider('X.509');
        const adminIdentity = await wallet.get('admin');
    
        const adminUser = await provider.getUserContext(adminIdentity, 'admin');
        const appUserIdentity = await wallet.get('appUser');
        console.log(3);

        const newappUser = await provider.getUserContext(appUserIdentity, 'appUser');
        const identityService = ca.newIdentityService();

        const identities = (await identityService.getAll(adminUser)).result.identities;
        // identities.forEach(element => {
        //     console.log(element);
        // });
                
        console.log(network.getChannel('mychannel').getEndorsers()[0].name);
        console.log(network.getChannel('mychannel').getEndorsers()[0].endpoint.creds);
        
        const contract = network.getContract('healthwork');
        let privData = {key: ccp.peers['peer0.org2.example.com'].privateKey.pem}
        let data = Buffer.from(JSON.stringify(privData));
        console.log(data);
        contract.createTransaction().setTransient({Priv_peer : data}).submit('initLedger');
        
        gateway.disconnect();
    }
    catch(ex){
        console.log("exception: " + ex);
    }
}
main();