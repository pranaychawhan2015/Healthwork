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
const { IdentityService } = require('fabric-ca-client');
const { stringify } = require('querystring');

async function main() {
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org1.example.com', 'connection-org1.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new CA client for interacting with the CA.
        const caURL = ccp.certificateAuthorities['ca.org1.example.com'].url;
        const caInfo = ccp.certificateAuthorities['ca.org1.example.com'];
        const mspId = ccp.organizations['Org1'].mspid;
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caInfo.tlsCACerts.pem, verify: false }, caInfo.caName);

        const ccpPath2 = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org2.example.com', 'connection-org2.json');
        const ccp2 = JSON.parse(fs.readFileSync(ccpPath2, 'utf8'));

        // Create a new CA client for interacting with the CA.
        const caURL2 = ccp2.certificateAuthorities['ca.org2.example.com'].url;
        const caInfo2 = ccp2.certificateAuthorities['ca.org2.example.com'];
        const mspId2 = ccp2.organizations['Org2'].mspid;
        const ca2 = new FabricCAServices(caURL2, { trustedRoots: caInfo2.tlsCACerts.pem, verify: false }, caInfo2.caName);
        
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the admin user.
        var docker = new Docker({socketPath: '/var/run/docker.sock'});
        let inputArray =  process.argv.slice(2)
        let container = docker.getContainer(inputArray[0])
        let results = await container.inspect()
        //console.log(results.Config.Env)
        let env = results.Config.Env.filter(x=>x.startsWith("CORE_PEER_LOCALMSPID"))
        let mspID = env[0].split("CORE_PEER_LOCALMSPID")
        let actualMSPID = mspID[1].replace("=", "")

        let peerID = results.Config.Env.filter(x=>x.startsWith("CORE_PEER_ENROLLMENT_ID"))[0].split("CORE_PEER_ENROLLMENT_ID")
        let actualpeerID = peerID[1].replace("=", "")


        results.Mounts.map(async (mount) =>  {
            if( mount.Destination == "/etc/hyperledger/fabric/msp"){
                //let list = bind.split(":")
                let actualMSPPath = mount.Source
                console.log(actualMSPPath)
                const keyPath = actualMSPPath + "/keystore/priv_sk";
                const certPath =  actualMSPPath + "/signcerts/cert.pem";
                const key = fs.readFileSync(keyPath).toString();
                const cert = fs.readFileSync(certPath).toString();
                
                const identity = {
                    credentials: {
                        certificate: cert,
                        privateKey: key,
                    },
                    mspId: actualMSPID,
                    type: 'X.509',
                };
                
                let adminIdentity = await wallet.get(actualMSPID);
                console.log("Admin", adminIdentity)
                if (!adminIdentity) {
                    let enrollment = null;
                    let x509Identity = null
                    if (actualMSPID == "Org1MSP"){
                        enrollment = await ca.enroll({ enrollmentID: 'admin', enrollmentSecret: 'adminpw', ecert:true});
                        x509Identity = {
                            credentials: {
                                certificate: enrollment.certificate,
                                privateKey: enrollment.key.toBytes(),
                            },
                            mspId: actualMSPID,
                            type: 'X.509',
                        };  
                    }else{
                        enrollment = await ca2.enroll({ enrollmentID: 'admin', enrollmentSecret: 'adminpw', ecert:true});
                        x509Identity = {
                            credentials: {
                                certificate: enrollment.certificate,
                                privateKey: enrollment.key.toBytes(),
                            },
                            mspId: actualMSPID,
                            type: 'X.509',
                        }; 
                    }
                    await wallet.put(actualMSPID, x509Identity);
                    adminIdentity = await wallet.get(actualMSPID);
                }                
                
                let identityService = null
                console.log(actualMSPID)
                if (actualMSPID == "Org2MSP"){
                    identityService = ca2.newIdentityService()
                }else{
                    identityService = ca.newIdentityService()
                }

                // build a user object for authenticating with the CA
                const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
                
                const adminUser = await provider.getUserContext(adminIdentity, actualMSPID);
                let resultResponses = await identityService.getOne(actualpeerID, adminUser)
                console.log("Response before update",resultResponses.result.attrs)
                
                const newAppUser = await provider.getUserContext(identity,actualpeerID);
                //var theIdentityRequest = { enrollmentID: actualpeerID, attrs: [{name:"Contractor2", value:"Pranay@447", ecert:true},{name:"New2", value:"Abc@7890", ecert:true}],enrollmentSecret: "efgsgshfgsfhgsdfhs"};
                let attrs = []
                // for(let i=0;i<33999;i++){
                //   attrs.push({name:"attr"+i, value:"value"+i, ecert:true})  
                // }
                attrs = JSON.parse(inputArray[1])
                //console.log(attrs.name)
                var theIdentityRequest = { enrollmentID: actualpeerID, attrs: attrs,enrollmentSecret: "efgsgshfgsfhgsdfhs"};

                let response = await identityService.update(actualpeerID, theIdentityRequest, adminUser);
                console.log("Response After Update", response.result.attrs);
                console.log(1)

                let enrollment = null;
                if (actualMSPID == "Org1MSP"){
                    enrollment = await ca.reenroll(newAppUser);
                    const x509Identity = {
                        credentials: {
                            certificate: enrollment.certificate,
                            privateKey: enrollment.key.toBytes(),
                        },
                        mspId: actualMSPID,
                        type: 'X.509',
                    };
                }else{
                    enrollment = await ca2.reenroll(newAppUser);
                    const x509Identity = {
                        credentials: {
                            certificate: enrollment.certificate,
                            privateKey: enrollment.key.toBytes(),
                        },
                        mspId: actualMSPID,
                        type: 'X.509',
                    };
                }


                //let allIdentities = await identityService.getAll(adminUser)
                //console.log("Identities", allIdentities)


                fs.writeFileSync(actualMSPPath + "/signcerts/cert.pem",enrollment.certificate);
                fs.writeFileSync(keyPath, enrollment.key.toBytes().toString());
                
                const { exec } = require('child_process');
                var yourscript = exec('/home/cps16/Documents/New/test-network/organizations/ccp-generate2.sh',
                        (error, stdout, stderr) => {
                            //console.log(stdout);
                            //console.log(stderr);
                            if (error !== null) {
                                console.log(`exec error: ${error}`);
                            }
                        });
                
            }
        })
        
        console.log('Successfully registered and enrolled admin user "appUser" and imported it into the wallet');

    } catch (error) {
        console.error(`Failed to register user "appUser": ${error}`);
        process.exit(1);
    }
}

main();
