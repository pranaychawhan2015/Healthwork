/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Gateway, Wallets } = require('fabric-network');
const FabricCAServices = require('fabric-ca-client');
const path = require('path');
const { buildCAClient, registerAndEnrollUser, enrollAdmin } = require('../../test-application/javascript/CAUtil.js');
const { buildCCPOrg1, buildCCPOrg2, buildWallet } = require('../../test-application/javascript/AppUtil.js');
const { randomInt } = require('crypto');

const myChannel = 'mychannel';
const myChaincodeName = 'marbles_private';

const memberAssetCollectionName = 'collectionMarbles';
const org1PrivateCollectionName = 'collectionMarblePrivateDetails';
const org2PrivateCollectionName = 'Org2MSPPrivateCollection';
const mspOrg1 = 'Org1MSP';
const mspOrg2 = 'Org2MSP';
const Org1UserId = 'appUser1';
const Org2UserId = 'appUser2';

const RED = '\x1b[31m\n';
const RESET = '\x1b[0m';

function prettyJSONString(inputString) {
    if (inputString) {
        return JSON.stringify(JSON.parse(inputString), null, 2);
    }
    else {
        return inputString;
    }
}

function doFail(msgString) {
    console.error(`${RED}\t${msgString}${RESET}`);
    process.exit(1);
}

function showTransactionData(transactionData) {
	const creator = transactionData.actions[0].header.creator;
	console.log(`    - submitted by: ${creator.mspid}-${creator.id_bytes.toString('hex')}`);
	for (const endorsement of transactionData.actions[0].payload.action.endorsements) {
		console.log(`    - endorsed by: ${endorsement.endorser.mspid}-${endorsement.endorser.id_bytes.toString('hex')}`);
	}
	const chaincode = transactionData.actions[0].payload.chaincode_proposal_payload.input.chaincode_spec;
	console.log(`    - chaincode:${chaincode.chaincode_id.name}`);
	console.log(`    - function:${chaincode.input.args[0].toString()}`);
	for (let x = 1; x < chaincode.input.args.length; x++) {
		console.log(`    - arg:${chaincode.input.args[x].toString()}`);
	}

	const readWriteSet = transactionData.actions[0].payload.action.proposal_response_payload.extension.results.ns_rwset[1].rwset.reads[0].version

	if (readWriteSet != null){
		console.log(` read write set`, readWriteSet)
	}

	const collection_hashed_rwset = transactionData.actions[0].payload.action.proposal_response_payload.extension.results.collection_hashed_rwset

	if (collection_hashed_rwset.length != 0){
		console.log(` hashed set`, collection_hashed_rwset)
	}
}

function verifyAssetData(org, resultBuffer, expectedId, color, size, ownerUserId, appraisedValue) {

    let asset;
    if (resultBuffer) {
        asset = JSON.parse(resultBuffer.toString('utf8'));
    } else {
        doFail('Failed to read asset');
    }
    console.log(`*** verify asset data for: ${expectedId}`);
    if (!asset) {
        doFail('Received empty asset');
    }
    if (expectedId !== asset.assetID) {
        doFail(`recieved asset ${asset.assetID} , but expected ${expectedId}`);
    }
    if (asset.color !== color) {
        doFail(`asset ${asset.assetID} has color of ${asset.color}, expected value ${color}`);
    }
    if (asset.size !== size) {
        doFail(`Failed size check - asset ${asset.assetID} has size of ${asset.size}, expected value ${size}`);
    }

    if (asset.owner.includes(ownerUserId)) {
        console.log(`\tasset ${asset.assetID} owner: ${asset.owner}`);
    } else {
        doFail(`Failed owner check from ${org} - asset ${asset.assetID} owned by ${asset.owner}, expected userId ${ownerUserId}`);
    }
    if (appraisedValue) {
        if (asset.appraisedValue !== appraisedValue) {
            doFail(`Failed appraised value check from ${org} - asset ${asset.assetID} has appraised value of ${asset.appraisedValue}, expected value ${appraisedValue}`);
        }
    }
}

function verifyAssetPrivateDetails(resultBuffer, expectedId, appraisedValue) {
    let assetPD;
    if (resultBuffer) {
        assetPD = JSON.parse(resultBuffer.toString('utf8'));
    } else {
        doFail('Failed to read asset private details');
    }
    console.log(`*** verify private details: ${expectedId}`);
    if (!assetPD) {
        doFail('Received empty data');
    }
    if (expectedId !== assetPD.assetID) {
        doFail(`recieved ${assetPD.assetID} , but expected ${expectedId}`);
    }

    if (appraisedValue) {
        if (assetPD.appraisedValue !== appraisedValue) {
            doFail(`Failed appraised value check - asset ${assetPD.assetID} has appraised value of ${assetPD.appraisedValue}, expected value ${appraisedValue}`);
        }
    }
}

async function initContractFromOrg1Identity() {
    console.log('\n--> Fabric client user & Gateway init: Using Org1 identity to Org1 Peer');
    // build an in memory object with the network configuration (also known as a connection profile)
    const ccpOrg1 = buildCCPOrg1();

    // build an instance of the fabric ca services client based on
    // the information in the network configuration
    const caOrg1Client = buildCAClient(FabricCAServices, ccpOrg1, 'ca.org1.example.com');

    // setup the wallet to cache the credentials of the application user, on the app server locally
    const walletPathOrg1 = path.join(__dirname, 'wallet/org1');
    const walletOrg1 = await buildWallet(Wallets, walletPathOrg1);

    // in a real application this would be done on an administrative flow, and only once
    // stores admin identity in local wallet, if needed
    await enrollAdmin(caOrg1Client, walletOrg1, mspOrg1);
    // register & enroll application user with CA, which is used as client identify to make chaincode calls
    // and stores app user identity in local wallet
    // In a real application this would be done only when a new user was required to be added
    // and would be part of an administrative flow
    await registerAndEnrollUser(caOrg1Client, walletOrg1, mspOrg1, Org1UserId, 'org1.department1');

    try {
        // Create a new gateway for connecting to Org's peer node.
        const gatewayOrg1 = new Gateway();
        //connect using Discovery enabled
        await gatewayOrg1.connect(ccpOrg1,
            { wallet: walletOrg1, identity: Org1UserId, discovery: { enabled: true, asLocalhost: true } });

        return gatewayOrg1;
    } catch (error) {
        console.error(`Error in connecting to gateway: ${error}`);
        process.exit(1);
    }
}

async function initContractFromOrg2Identity() {
    console.log('\n--> Fabric client user & Gateway init: Using Org2 identity to Org2 Peer');
    const ccpOrg2 = buildCCPOrg2();
    const caOrg2Client = buildCAClient(FabricCAServices, ccpOrg2, 'ca.org2.example.com');

    const walletPathOrg2 = path.join(__dirname, 'wallet/org2');
    const walletOrg2 = await buildWallet(Wallets, walletPathOrg2);

    await enrollAdmin(caOrg2Client, walletOrg2, mspOrg2);
    await registerAndEnrollUser(caOrg2Client, walletOrg2, mspOrg2, Org2UserId, 'org2.department1');

    try {
        // Create a new gateway for connecting to Org's peer node.
        const gatewayOrg2 = new Gateway();
        await gatewayOrg2.connect(ccpOrg2,
            { wallet: walletOrg2, identity: Org2UserId, discovery: { enabled: true, asLocalhost: true } });

        return gatewayOrg2;
    } catch (error) {
        console.error(`Error in connecting to gateway: ${error}`);
        process.exit(1);
    }
}


// Main workflow : usecase details at asset-transfer-private-data/chaincode-go/README.md
// This app uses fabric-samples/test-network based setup and the companion chaincode
// For this usecase illustration, we will use both Org1 & Org2 client identity from this same app
// In real world the Org1 & Org2 identity will be used in different apps to achieve asset transfer.
async function main() {
    try {

        /** ******* Fabric client init: Using Org1 identity to Org1 Peer ********** */
        const gatewayOrg1 = await initContractFromOrg1Identity();
        const networkOrg1 = await gatewayOrg1.getNetwork(myChannel);
        const contractOrg1 = networkOrg1.getContract(myChaincodeName);
        // Since this sample chaincode uses, Private Data Collection level endorsement policy, addDiscoveryInterest
        // scopes the discovery service further to use the endorsement policies of collections, if any
        contractOrg1.addDiscoveryInterest({ name: myChaincodeName, collectionNames: [memberAssetCollectionName, org1PrivateCollectionName] });

        /** ~~~~~~~ Fabric client init: Using Org2 identity to Org2 Peer ~~~~~~~ */
        const gatewayOrg2 = await initContractFromOrg2Identity();
        const networkOrg2 = await gatewayOrg2.getNetwork(myChannel);
        const contractOrg2 = networkOrg2.getContract(myChaincodeName);
        contractOrg2.addDiscoveryInterest({ name: myChaincodeName, collectionNames: [memberAssetCollectionName, org2PrivateCollectionName] });
        
        let transaction;
        let listener;
    
        try {
            // first create a listener to be notified of chaincode code events
            // coming from the chaincode ID "events"
            listener = async (event) => {
                // The payload of the chaincode event is the value place there by the
                // chaincode. Notice it is a byte data and the application will have
                // to know how to deserialize.
                // In this case we know that the chaincode will always place the asset
                // being worked with as the payload for all events produced.
                
                //const asset = JSON.parse(event.payload.toString());
                console.log(`<-- Contract Event Received: ${event.eventName}`);
                // show the information available with the event
                console.log(`*** Event: ${event.eventName}`);
                // notice how we have access to the transaction information that produced this chaincode event
                const eventTransaction = event.getTransactionEvent();
                console.log(`*** transaction: ${eventTransaction.transactionId} status:${eventTransaction.status}`);
                showTransactionData(eventTransaction.transactionData);
                // notice how we have access to the full block that contains this transaction
                const eventBlock = eventTransaction.getBlockEvent();
                console.log(`*** block: ${eventBlock.blockNumber.toString()}`);
            };
            // now start the client side event service and register the listener
            console.log(`Start contract event stream to peer in Org1`);
            await contractOrg1.addContractListener(listener, {type: 'private'})
            await networkOrg1.addBlockListener(listener, {type: 'private'});
        
        } catch (eventError) {
            console.log(`<-- Failed: Setup contract events - ${eventError}`);
        }
    
        
        try {
            // Sample transactions are listed below
            // Add few sample Assets & transfers one of the asset from Org1 to Org2 as the new owner

            let randomNumber = Math.floor(Math.random() * 1000) + 1;

            let assetId = "Sample" + randomNumber
            let result;
            let assetData = { name: assetId, color: "Blue", size: 20, owner: "Pranay", price: 236736};

            console.log('\n**************** As Org1 Client ****************');
            console.log('Adding Assets to work with:\n--> Submit Transaction: CreateAsset ' + assetId);
            let statefulTxn = contractOrg1.createTransaction('InitMarble');
            //if you need to customize endorsement to specific set of Orgs, use setEndorsingOrganizations
            //statefulTxn.setEndorsingOrganizations(mspOrg1);
            let tmapData = Buffer.from(JSON.stringify(assetData));
            statefulTxn.setTransient({
                marble: tmapData
            });
            result = await statefulTxn.submit();

            console.log('\n--> Evaluate Transaction: ReadAssetPrivateDetails from ' + org1PrivateCollectionName);
            // ReadAssetPrivateDetails reads data from Org's private collection. Args: collectionName, assetID
            result = await contractOrg1.submitTransaction('ReadMarblePrivateDetails', assetId);
            console.log(`<-- result: ${prettyJSONString(result.toString())}`);
            //console.log(`<-- result: ${resu1lt}`);
            //verifyAssetPrivateDetails(result, "Sample1", 100);

            let hash = await contractOrg1.submitTransaction('GetMarbleHash', memberAssetCollectionName, assetId)
            console.log(`<-- hash: ${Buffer.from(hash, 'utf-8').toString()}`);

            contractOrg1.removeContractListener(listener);
            networkOrg1.removeBlockListener(listener);

        } finally {
            // Disconnect from the gateway peer when all work for this client identity is complete
            gatewayOrg1.disconnect();
            gatewayOrg2.disconnect();
        }
    } catch (error) {
        console.error(`Error in transaction: ${error}`);
        if (error.stack) {
            console.error(error.stack);
        }
        process.exit(1);
    }
}

main();
