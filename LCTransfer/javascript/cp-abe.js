'use strict';

const { Gateway, Wallets, HsmX509Provider, Transaction,GatewayOptions, DefaultEventHandlerStrategies } = require('fabric-network');
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
const { OutputFileType } = require('typescript');
const { syncBuiltinESMExports } = require('module');
//require('node-go-require');

class MyTransactionEventHandler extends TransactionEventHandler {
    /**
     * Called to initiate listening for transaction events.
     */
    async startListening() { 
        console.log("Event started") }

    /**
     * Wait until enough events have been received from peers to satisfy the event handling strategy.
     * @throws {Error} if the transaction commit is not successfully confirmed.
     */
    async waitForEvents() { console.log("wait for event") }

    /**
     * Cancel listening for events.
     */
    cancelListening() { console.log("Cancel listening") }
}

async function  main(){
    try{

        const { exec, execSync, execFile, execFileSync } = require('child_process');
        let outputArray = []
        
        var createTransactionEventHandler = function (transactionId, network) {
            /* Your implementation here */
            //var mspId = network.getGateway().getIdentity().mspId;
            var myOrgPeers = network.getChannel().getEndorsers();
            return new MyTransactionEventHandler(transactionId, network, myOrgPeers);
        };

        let connectOptions = {
            eventHandlerOptions: {
                strategy: createTransactionEventHandler
            }
        };


       let blockListener = async (event) => {

            console.log("--------------------------------------------------------------")
            console.log(`<-- Block Event Received - block number: ${event.blockNumber.toString()}`);
        
            const transEvents = event.getTransactionEvents();
            for (const transEvent of transEvents) {
                console.log(`*** transaction event: ${transEvent.transactionId}`);
                // if (transEvent.privateData) {
                //     for (const namespace of transEvent.privateData.ns_pvt_rwset) {
                //         console.log(`    - private data: ${namespace.namespace}`);
                //         for (const collection of namespace.collection_pvt_rwset) {
                //             console.log(`     - collection: ${collection.collection_name}`);
                //             if (collection.rwset.reads) {
                //                 for (const read of collection.rwset.reads) {
                //                     console.log(`       - read set - ${BLUE}key:${RESET} ${read.key}  ${BLUE}value:${read.value.toString()}`);
                //                 }
                //             }
                //             if (collection.rwset.writes) {
                //                 for (const write of collection.rwset.writes) {
                //                     console.log(`      - write set - ${BLUE}key:${RESET}${write.key} ${BLUE}is_delete:${RESET}${write.is_delete} ${BLUE}value:${RESET}${write.value.toString()}`);
                //                 }
                //             }
                //         }
                //     }
                // }
                if (transEvent.transactionData) {
                    showTransactionData(transEvent.transactionData);
                }
            }
        }
      
        var yourscript = execFileSync('/home/cps16/Documents/New/LCTransfer/javascript/runfabcar.sh')

       
    outputArray = yourscript.toString().split(" ");
    let outputArray2 = outputArray[1].toString().split("<nil>")
    
    let outputArray3 = outputArray2[1].toString().split(`{"policy`)
    let dataString = outputArray3[0]
    let policyString = `{"policy` + outputArray3[1]

    console.log(dataString)
    console.log(policyString)

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
       await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } }, connectOptions);
   
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
       // mychannel.getEndorsers().map(async(element) => {
       //     if(element.name.startsWith("peer0.org1.example.com") )
       //     {
       //         endorsers.push(element);
       //     }
       //     if(element.name.startsWith("peer0.org2.example.com")){
       //         endorsers.push(element);
       //     }
       //     let contract = network.getContract('LC_Transfer')
       // 	// response contains an array of collection definitions
       //     let transaction = contract.createTransaction('getData');
       //     let endorsersArray = []
       //     endorsersArray.push(element)
       //     let result = await transaction.setEndorsingPeers(endorsersArray).evaluate('96f082f3e5a0f67fd30103185f00359f')
       //     console.log("testing", result)
       // })
       //console.log("MSP", mychannel.getMsp("Org1MSP"))
       //console.log("endorsers", endorsers)
        
       //  let myMap = new Map()
        //  myMap.set("Email", "Pranay@gmail.com")
        //  myMap.set("Name", "Name")
         
        //  var str = JSON.stringify(Array.from( myMap.entries())); 
        //  console.log(str)
         
        //   const contract = network.getContract('LC_Transfer');
         //   await contract.submitTransaction('createRecord', str)
         
         for(let i=0;i<1000; i++){
         const discovery = new DiscoveryService('LC_Transfer', network.getChannel());
        //discovery.targets = endorsers;
        const userContext = await provider.getUserContext(appUserIdentity, "appUser");
  
        const discoverer = new Discoverer("appUser", network.getChannel().client, 'Org1MSP');
        //console.log("endorser", endorsers[0].name)
        await discoverer.connect(mychannel.getEndorsers()[0].endpoint);
       
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
        // const discovery_results = await discovery.send({targets: [discoverer], asLocalhost: true});
        //   //testUtil.logMsg('\nDiscovery test 1 results :: ' + JSON.stringify(discovery_results));


        //    // input to the build a proposal request
        //   let build_proposal_request = {
        //     // args: [str],
        //     // transientMap: {
        //     // 	'marblename': Buffer.from('marble1'), // string <-> byte[]
        //     // 	'color': Buffer.from('red'), // string <-> byte[]
        //     // 	'owner': Buffer.from('John'), // string <-> byte[]
        //     // 	'size': Buffer.from('85'), // string <-> byte[]
        //     // 	'price': Buffer.from('99') // string <-> byte[]
        //     // },
            
        //     // fcn: 'ChangeCarOwner',
        //     // args:["CAR1", "NEw1"]
            
        //     args:[dataString, policyString],
        //     fcn: 'CreateRecord'
        //   };
 
        //    endorsement.build(new IdentityContext(userContext, network.getChannel().client), build_proposal_request);
        //    endorsement.sign(new IdentityContext(userContext, network.getChannel().client));       
        //    const handler = discovery.newHandler();
           
        //    let previousCount = mychannel.getEndorsers().length;
        //    console.log("previouscount", previousCount)

        //    // do not specify 'targets', use a handler instead
        //    let  endorse_request = {
        //        targets: mychannel.getEndorsers(),
        //        requestTimeout: 60000
        //    };
           
        //    let endorse_results = await endorsement.send(endorse_request); 
        //    let targets = mychannel.getEndorsers()
           
        //    endorse_results.responses.forEach(element=>{
        //     console.log("1st payload ", element.response.payload.toString())
        //     console.log("2nd payload", element.payload.toString())
        //     console.log("3rd", element)
        //     if (element.response.status == 302){
        //        let elementToBeRetained =  targets.filter(x=>x.name != element.connection.name)                            
        //        targets = elementToBeRetained 
        //     }
        //    })
        //    console.log("New Targtes", targets, "length1", targets.length, "length2", previousCount)
        //    //endorse_results.responses = responses
        //    if (targets.length != previousCount){
        //     console.log("condition matched")
        //     endorse_request = {
        //         targets: targets,
        //         requestTimeout: 60000
        //     };
        //     endorse_results = await endorsement.send(endorse_request); 
        //     endorse_results.responses.forEach(element=>{
        //         console.log("REsponse new ", element)
        //     })
        //     console.log("new endorser results", endorse_results)
        // }
 
        //    //console.log("endorsed_results", endorse_results)
        //    const commit = endorsement.newCommit();
           
        //    const  commit_request = {
        //      handler: handler,
        //      //targets:mychannel.getCommitters(),
        //      requestTimeout: 60000
        //      };
             
            
        //    commit.chaincodeId = 'LC_Transfer';
        //    commit.build(new IdentityContext(userContext, network.getChannel().client), build_proposal_request);
        //    commit.sign(new IdentityContext(userContext, network.getChannel().client));
        //    let committedResults = await commit.send(commit_request); 
        //    console.log("commit result", committedResults)
            
        //    const listener = await network.addBlockListener(blockListener);
           
        //sleep(1000);
        }
          //await network.getContract('LCTransfer').submitTransaction("QueryCar", "CAR0")
       
       // try {
       
       // })
           
           //console.log('response', response)
       // } catch (error) {
       // 	throw error;
       // }
        await network.getContract('LC_Transfer').submitTransaction('CreateRecord',dataString,policyString);
        gateway.disconnect();
        }

       catch(ex){
         console.log("exception: " + ex);
        }
    }

    function showTransactionData(transactionData) {
        console.log(JSON.stringify(transactionData))
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
        console.log("all actions", transactionData.actions)
    }

    function sleep(ms) {
        return new Promise((resolve) => {
          setTimeout(resolve, ms);
        });
      }
main();
