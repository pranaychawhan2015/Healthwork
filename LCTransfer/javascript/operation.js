/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Gateway, Wallets, HsmX509Provider, Transaction,QueryHandlerFactory, DefaultQueryHandlerStrategies } = require('fabric-network');
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
//const { json } = require('stream/consumers');
//const { json } = require('node:stream/consumers');
//const { json } = require('stream/consumers');

//const ClientIdentity = require('fabric-shim').ClientIdentity;

async function main() {
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org1.example.com', 'connection-org1.json');
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
        await gateway.connect(ccp, { wallet, identity: 'admin', discovery: { enabled: true, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');
        
        const caURL = ccp.certificateAuthorities['ca.org1.example.com'].url;
        const ca = new FabricCAServices(caURL);
        
        const provider = wallet.getProviderRegistry().getProvider('X.509');
        const adminIdentity = await wallet.get('admin');

        const adminUser = await provider.getUserContext(adminIdentity, 'admin');
        const appUserIdentity = await wallet.get('appUser');

        const newAppUser = await provider.getUserContext(appUserIdentity, 'appUser');
        const identityService = ca.newIdentityService();
            

        // Get the contract from the network.
        const contract = network.getContract('student');
        
        
        //let cid = new ClientIdentity()
        console.log(1);
        await contract.submitTransaction('addStudent','pranaychawhan@gmail.com', 'hyderabad, masab tank', 'Pranay', 'Chawhan', '9970546712', 'Hyderabad');
        console.log(2);
        console.log(`added student1: pranaychawhan@gmail.com`);
        let student2 = {email: 'kishore@gmail.com', mobile: '8890245672', firstName:'kishor', lastName: 'gawte', address:'nagpur, mahal'}; 
        await contract.submitTransaction('addStudent','kishore@gmail.com', 'nagpur, mahal', 'kishor', 'gawte', '8890245672', 'nagpur');
        console.log(`added student2: kishore@gmail.com`);
        let result3 = await contract.submitTransaction('queryStudent','pranaychawhan@gmail.com');
        console.log(`Data Found for :pranaychawhan@gmail.com ${result3}`);
        let result4 = await contract.submitTransaction('queryAllStudents');
        console.log(`Data Found for All students: ${result4.toString()}`);
        await contract.submitTransaction('editStudent', 'pranaychawhan2015@gmail.com', '9972901232', 'new addr', 'firstName', 'lastName', 'city');
        let result5 = await contract.submitTransaction('queryStudent','pranaychawhan@gmail.com');
        console.log(`Updated Data For pranaychawhan2015@gmail.com: ${result5.toString()}`);
        // Disconnect from the gateway.
        gateway.disconnect();
        
        
    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        process.exit(1);
    }
}

main();

//module.exports.main = main;
