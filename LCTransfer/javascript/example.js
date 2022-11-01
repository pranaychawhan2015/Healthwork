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

        const newappUser = await provider.getUserContext(appUserIdentity, 'appUser');
        const identityService = ca.newIdentityService();

        const identities = (await identityService.getAll(adminUser)).result.identities;
        identities.forEach(element => {
            console.log(element);
        });
                
        //console.log(network.getChannel('mychannel').getEndorsers()[0].name);
        //console.log(network.getChannel('mychannel').getEndorsers()[0].endpoint.creds);
        let endorsers = [];
		let mychannel = network.getChannel('mychannel')
        mychannel.getEndorsers().map(async(element) => {
            if(element.name.startsWith("peer0.org1.example.com") )
            {
                endorsers.push(element);
            }
            if(element.name.startsWith("peer0.org2.example.com")){
                endorsers.push(element);
            }
            let contract = network.getContract('LC_Transfer')
			// response contains an array of collection definitions
            let transaction = contract.createTransaction('getData');
            let endorsersArray = []
            endorsersArray.push(element)
            let result = await transaction.setEndorsingPeers(endorsersArray).evaluate('96f082f3e5a0f67fd30103185f00359f')
            console.log("testing", result)
        })
        console.log("MSP", mychannel.getMsp("Org1MSP"))
		//console.log("endorsers", endorsers)
          let myMap = new Map()
		  myMap.set("Email", "Pranay@gmail.com")
		  myMap.set("Name", "Name")
		  
		  var str = JSON.stringify(Array.from( myMap.entries())); 
		  console.log(str)
		  //   const contract = network.getContract('LC_Transfer');
		  //   await contract.submitTransaction('createRecord', str)
		  const discovery = new DiscoveryService('LC_Transfer', network.getChannel());
         //discovery.targets = endorsers;
         const userContext = await provider.getUserContext(appUserIdentity, "appUser");
   
         const discoverer = new Discoverer("appUser", network.getChannel().client, 'Org1MSP');
         console.log("endorser", endorsers[0].name)
		 await discoverer.connect(endorsers[0].endpoint);
		

         const endorsement = network.getChannel().newEndorsement('LC_Transfer');

        //  const eventhandler = new TransactionEventHandler(endorsement.getTransactionId(), network, DefaultQueryHandlerStrategies.PREFER_MSPID_SCOPE_ROUND_ROBIN);
		//  console.log(4);

		//  await eventhandler.startListening();
        //  console.log('event' + eventhandler.peers);
        //  await eventhandler.waitForEvents();
        //  console.log('event' + eventhandler.peers);

         discovery.build(new IdentityContext(userContext, network.getChannel().client), {endorsement: endorsement});
         discovery.sign(new IdentityContext(userContext, network.getChannel().client));
         // discovery results will be based on the chaincode of the endorsement
         const discovery_results = await discovery.send({targets: [discoverer], asLocalhost: true});
           //testUtil.logMsg('\nDiscovery test 1 results :: ' + JSON.stringify(discovery_results));
       
           // input to the build a proposal request
           let build_proposal_request = {
            // args: [str],
			// transientMap: {
			// 	'marblename': Buffer.from('marble1'), // string <-> byte[]
			// 	'color': Buffer.from('red'), // string <-> byte[]
			// 	'owner': Buffer.from('John'), // string <-> byte[]
			// 	'size': Buffer.from('85'), // string <-> byte[]
			// 	'price': Buffer.from('99') // string <-> byte[]
			// },
			fcn: 'initLedger'
            // args:['96f082f3e5a0f67fd30103185f00359f'],
            // fcn: 'getData'
          };

           endorsement.build(new IdentityContext(userContext, network.getChannel().client), build_proposal_request);
           endorsement.sign(new IdentityContext(userContext, network.getChannel().client));       
           const handler = discovery.newHandler();
           
           
           // do not specify 'targets', use a handler instead
           const  endorse_request = {
               targets: endorsers,
               requestTimeout: 60000
           };
           
           const endorse_results = await endorsement.send(endorse_request); 
  
		   endorse_results.responses.forEach(element=>{
				console.log("1st payload ", element.response.payload.toString())
				console.log("2nd payload", element.payload.toString())
				console.log("3rd", element)
		   })

		   //console.log("endorsed_results", endorse_results)
           const commit = endorsement.newCommit();
           
           const  commit_request = {
             handler: handler,
             requestTimeout: 60000
             };

           commit.chaincodeId = 'LC_Transfer';
           commit.build(new IdentityContext(userContext, network.getChannel().client), build_proposal_request);
           commit.sign(new IdentityContext(userContext, network.getChannel().client));
           let committedResults = await commit.send(commit_request); 
		   console.log("commit result", committedResults)

		   const request = {
			chaincodeId: commit.chaincodeId,
			target: endorsers
		};
		
		// try {
        
        // })
            
            console.log('response', response)
		// } catch (error) {
		// 	throw error;
		// }
		

          gateway.disconnect();
       }
       catch(ex){
         console.log("exception: " + ex);
        }
    }
main();
