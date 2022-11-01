/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Wallets, Gateway } = require('fabric-network');
const FabricCAServices = require('fabric-ca-client');
const fs = require('fs');
const path = require('path');
var Docker = require('dockerode');
const { userInfo } = require('os');

async function main() {
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org1.example.com', 'connection-org1.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new CA client for interacting with the CA.
        const caURL = ccp.certificateAuthorities['ca.org1.example.com'].url;
        const ca = new FabricCAServices(caURL);

        const identityLabel = 'peer0';
        const adminLabel = 'admin';
        
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        const keyPath = "/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/keystore/priv_sk";

        const cert = fs.readFileSync("/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/signcerts/cert.pem").toString();
        const key = fs.readFileSync(keyPath).toString();
        
        const identity = {
            credentials: {
                certificate: cert,
                privateKey: key,
            },
            mspId: 'Org1MSP',
            type: 'X.509',
        };
        
        await wallet.put(identityLabel, identity);

        // Check to see if we've already enrolled the admin user.
        const adminIdentity = await wallet.get(adminLabel);
        if (!adminIdentity) {
            console.log('An identity for the admin user "admin" does not exist in the wallet');
            console.log('Run the enrollAdmin.js application before retrying');
            return;
        }

        // build a user object for authenticating with the CA
        const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
        
        const adminUser = await provider.getUserContext(adminIdentity, adminLabel);

        const newAppUser = await provider.getUserContext(identity, identityLabel);

        const identityService = ca.newIdentityService();
        
        var theIdentityRequest = { enrollmentID: identityLabel, attrs: [{name:"Contractor", value:"Pranay@447", ecert:true},{name:"Doctor4", value:"Abc@789", ecert:true}],enrollmentSecret: "peer0pw"};
        let response = await identityService.update(identityLabel, theIdentityRequest, adminUser);
        console.log(response.result.attrs);

        const enrollment = await ca.reenroll(newAppUser);
        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: 'Org1MSP',
            type: 'X.509',
        };

        await wallet.put(identityLabel, x509Identity);
        console.log("Identity",x509Identity);
        //Write the newly updated identity in the folder
        fs.writeFileSync("/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/signcerts/cert.pem",enrollment.certificate);
        fs.writeFileSync(keyPath, enrollment.key.toBytes());
        
        const { exec } = require('child_process');
var yourscript = exec('/home/cps16/Documents/New/test-network/organizations/ccp-generate2.sh',
        (error, stdout, stderr) => {
            console.log(stdout);
            console.log(stderr);
            if (error !== null) {
                console.log(`exec error: ${error}`);
            }
        });
        
        var docker = new Docker({socketPath: '/var/run/docker.sock'});
        let container = docker.getContainer('peer0.org1.example.com')
        let results = await container.inspect()
        //console.log(results.Config.Env)
        let env = results.Config.Env.filter(x=>x.startsWith("CORE_PEER_LOCALMSPID"))
        let mspID = env[0].split("CORE_PEER_LOCALMSPID")
        
        results.Mounts.map(async (mount) =>  {
            if( mount.Destination == "/etc/hyperledger/fabric/msp"){
                //let list = bind.split(":")
                let actualMSPPath = mount.Source
                console.log(actualMSPPath)
                const keyPath = actualMSPPath + "/keystore/priv_sk";

                const cert = fs.readFileSync(actualMSPPath + "/signcerts/cert.pem").toString();
                const key = fs.readFileSync(keyPath).toString();
                
                const identity = {
                    credentials: {
                        certificate: cert,
                        privateKey: key,
                    },
                    mspId: mspID,
                    type: 'X.509',
                };

                var theIdentityRequest = { enrollmentID: identityLabel, attrs: [{name:"Contractor2", value:"Pranay@447", ecert:true},{name:"NewDoctor2", value:"Abc@7890", ecert:true}],enrollmentSecret: "peer0pw2"};
                let response = await identityService.update(identityLabel, theIdentityRequest, adminUser);
                console.log(response.result.attrs);
        
                const enrollment = await ca.reenroll(newAppUser);
                const x509Identity = {
                    credentials: {
                        certificate: enrollment.certificate,
                        privateKey: enrollment.key.toBytes(),
                    },
                    mspId: mspID,
                    type: 'X.509',
                };

                let allIdentities = await identityService.getAll(adminUser)
                console.log("Identities", allIdentities)
                
                fs.writeFileSync(actualMSPPath + "/signcerts/cert.pem",enrollment.certificate);
                fs.writeFileSync(keyPath, enrollment.key.toBytes());
            }
        })
        
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });        
  
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');
        //network.getChannel().addEndorser()

        console.log("MSP", network.getChannel().getMsp())
        gateway.disconnect()
        console.log('Successfully registered and enrolled admin user "appUser" and imported it into the wallet');

    } catch (error) {
        console.error(`Failed to register user "appUser": ${error}`);
        process.exit(1);
    }
}

main();
