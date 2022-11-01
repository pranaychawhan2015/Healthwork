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
const {couchdb, createClient} = require('couchdb')
const NodeCouchdb = require('node-couchdb')
async function main() {
    try {
        
        var docker = new Docker({socketPath: '/var/run/docker.sock'});
        let network = docker.getNetwork('fabric_test')
        let inspection = await network.inspect()
        Object.values(inspection.Containers).map(async (x)=>{
            let container = docker.getContainer(x.Name)
            let results = await container.inspect()

            console.log(results.Config.Env)
            let env = results.Config.Env.filter(x=>x.startsWith("CORE_PEER_LOCALMSPID"))
            if (env.length != 0) {
                let mspID = env[0].split("CORE_PEER_LOCALMSPID")
            }
            console.log(env)
            var client  = couchdb.createClient(5984, 'localhost');
            let allDbs = await client.allDbs()
            console.log(allDbs)
        })

        
        
        console.log('Successfully registered and enrolled admin user "appUser" and imported it into the wallet');

    } catch (error) {
        console.error(`Failed to register user "appUser": ${error}`);
        process.exit(1);
    }
}

main();
