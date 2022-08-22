/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;
//const peerIdentity = require('fa');
const fabric_shim_api = require('fabric-shim-api') 
const fabric_shim = require('fabric-shim')
var uuid = require('uuid');
const crypto = require("crypto");
var PhoneNumber = require( 'awesome-phonenumber' );
//var Endorser = require('fabric-common');


class HealthWork extends Contract {

    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');
        const patients = [
            {
                Name: 'Raju',
                Age: 24,
                Doctor_Specialization: 'Orthopedics',
                Disease: 'Osteoarthritis',
                Email: 'Raju@google.com',
            },
            // {
            //     Name: 'API',
            //     Value: 'Public Key'
            // }
            {
                Name: 'Sam',
                Age: 50,
                Doctor_Specialization: 'Orthopedics',
                Disease: 'hepatitisB',
                Email: 'Sam@google.com'
            },
            {
                Name: 'Mangesh',
                Age: 40,
                Doctor_Specialization: 'Obstetrics and Gynecology',
                Disease: 'Cervical Dysplasia',
                Email: 'Mangesh@google.com'
            },
            {
                Name: 'Michael',
                Age: 30,
                Doctor_Specialization: 'Obstetrics and Gynecology',
                Disease: 'Menstrual Disorders',
                Email: 'Michael@google.com'
            },
            {
                Name: 'Tyler',
                Age: 37,
                Doctor_Specialization: 'Dermatology',
                Disease: 'Sunburn',
                Email: 'Tyler@google.com'
            },
            {
                Name: 'Meena',
                Age: 38,
                Doctor_Specialization: 'Pediatrics',
                Disease: 'chickenpox',
                Email: 'Meena@google.com'
            },
            {
                Name: 'Cain',
                Age: 41,
                Doctor_Specialization: 'Radiology',
                Disease: 'Anemia',
                Email: 'Cain@google.com'
            },
            {
                Name: 'Vinit',
                Age: 44,
                Doctor_Specialization: 'Radiology',
                Disease: 'Appendicitis',
                Email: 'vinit@google.com'
            },
            {
                Name: 'Sunita',
                Age: 46,
                Doctor_Specialization: 'Obstetrics and Gynecology',
                Disease: 'cirrhosis',
                Email: 'Sunita@google.com'
            },
            {
                Name: 'Samail',
                Age: 34,
                Doctor_Specialization: 'Obstetrics and Gynecology',
                Disease: 'Botulism',
                Email: 'Samail@google.com'
            },
        ];

        for (let i = 0; i < patients.length; i++) {
            patients[i].docType = 'patient';
            patients[i].patientNumber = 'patient ' + i;
            await ctx.stub.putState(patients[i].Email, Buffer.from(JSON.stringify(patients[i])));
            console.info('Added <--> ', patients[i]);
        }

        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ Key: key, Record: record });
        }
        console.info('============= END : Initialize Ledger ===========');

        return JSON.stringify(allResults);
    }

    async createRecord(ctx, msg){
        var map = new Map(JSON.parse(msg))
        for (let [key, value] of map.entries()) {
            console.log(key + ' - ' + value)
        }
        let success = await ctx.stub.putState(map.get("Email"), JSON.stringify(map))
        let txMap = await ctx.getTransient()
        return success,"Working good",txMap
    }
    
    async queryPatient(ctx, msg, policy) {
        let originalMessage =  Buffer.from(JSON.stringify(msg.toString('ascii'))) 
        const patientAsBytes = await ctx.stub.getState(originalMessage.email); // get the car from chaincode state
        if (!patientAsBytes || patientAsBytes.length === 0) {
            return new String(`${originalMessage.email} does not exist`);
        }
        console.log(patientAsBytes.toString());
        return patientAsBytes.toString();
    }

    async noop(ctx, data)
    {
        return data;
    }

    async createPatient(ctx, msg, policy) {
        console.info('============= START : Create Car ===========');
        console.log(msg)
        let originalMessage =  JSON.parse(msg.toString('ascii')) 
        console.log(originalMessage)
        originalMessage = JSON.parse(this.hex_to_ascii(originalMessage.Value))
        if(originalMessage.patientNumber == null || originalMessage.Name == null || originalMessage.Email == null || originalMessage.Organization == null || originalMessage.Adhar == null || originalMessage.Age == null || originalMessage.Doctor_Specialization == null || originalMessage.Disease == null)
        {
            return new String("One of the parameters are missing");
        }

        let patientNumber = originalMessage.patientNumber
        let Name = originalMessage.Name
        let Age = originalMessage.Age
        let Doctor_Specialization = originalMessage.Doctor_Specialization

        let Email = originalMessage.Email
        let Adhar = originalMessage.Adhar
        let Organization = originalMessage.Organization

        const patient = {
            patientNumber,
            docType: 'patient',
            Name,
            Age,
            Doctor_Specialization,
            Disease,
            Email,
            Adhar,
            Organization
        };
        
        //const result =  ctx.stub.getSignedProposal();
        await ctx.stub.putState(Email, Buffer.from(JSON.stringify(patient)));
        
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ Key: key, Record: record });
        }

        return JSON.stringify(allResults);

        //return result;
        //console.info('============= END : Create Car ===========');
    }

    hex_to_ascii(str1)
    {
	    var hex  = str1.toString();
	    var str = '';
	    for (var n = 0; n < hex.length; n += 2) {
		    str += String.fromCharCode(parseInt(hex.substr(n, 2), 16));
	    }
	    return str;
    }

    async queryAllPatients(ctx,msg, policy) {
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ Key: key, Record: record });
        }
        
        // const cid = new ClientIdentity(ctx.stub);
        // const result = await cid.getAttributeValue("Contractor");
        // if(result != null)
        // {
        //     allResults.push(result.toString());
        // }

        console.info(allResults);
        return JSON.stringify(allResults);
    }

    async changePatientName(ctx, msg, policy) {
        console.info('============= START : changeCarOwner ===========');
        let originalMessage =  Buffer.from(JSON.stringify(msg.toString('ascii'))) 
        let email = originalMessage.email
        let patientNumber = originalMessage.patientNumber
        let newName = originalMessage.newName
        const patientAsBytes = await ctx.stub.getState(email); // get the car from chaincode state
        if (!patientAsBytes || patientAsBytes.length === 0) {
            return new String(`${patientNumber} does not exist`);
        }
        if(newName == null)
        {
            return new String("Please Provide new Doctor Name");
        }
        const patient = JSON.parse(patientAsBytes.toString());
        patient.Name = newName;

        const result = await ctx.stub.putState(email, Buffer.from(JSON.stringify(patient)));
        
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ Key: key, Record: record });
        }
        ctx.stub.
        console.info('============= END : changeCarOwner ===========');

        return JSON.stringify(allResults);
        
    }
    
    async deletePatient(ctx, msg, policy)
    { 
        let originalMessage =  Buffer.from(JSON.stringify(msg.toString('ascii'))) 
        let email = originalMessage.email
        let patientNumber = originalMessage.patientNumber

        const patientAsBytes = await ctx.stub.getState(email); // get the car from chaincode state
        if (!patientAsBytes || patientAsBytes.length === 0) {
            return new String(`${patientNumber} does not exist`);
        }

        await ctx.stub.deleteState(email);

        const startKey = '';
        const endKey = '';
        const allResults = [];

        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ Key: key, Record: record });
        }

        return JSON.stringify(allResults);
    }

    async deleteAllPatients(ctx, msg, policy)
    {
        const startKey = '';
        const endKey = '';

        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
                await ctx.stub.deleteState(key);
        }
        
        return JSON.stringify('');
    }

    async testsampleReport(ctx, msg, policy)
    {
        let originalMessage =  Buffer.from(JSON.stringify(msg.toString('ascii'))) 

        let email = originalMessage.email
        let patientNumber = originalMessage.patientNumber
        const patientAsBytes = await ctx.stub.getState(email); // get the car from chaincode state
        if (!patientAsBytes || patientAsBytes.length === 0) {
            return new String(`${patientNumber} does not exist`);
        }
        let patient = JSON.parse(patientAsBytes.toString());
        const id = crypto.randomBytes(16).toString("hex");
        patient.sample_ID = id;
        const facilities = ['UPHC Shanti Nagar', 'UPHC Mehdipattnam'];
        const resultTypes = ['Positive', 'Negative'];
        const specimanTypes = ['Holotype', 'Lectotype', 'Neotype', 'Onomatophore'];

        patient.Facility_Name = facilities[Math.floor(Math.random()*facilities.length)];
        const regionCode = PhoneNumber.getRegionCodeForCountryCode(91);
        patient.Facility_Contact= PhoneNumber.getExample(regionCode, 'mobile');
        patient.Speciman_Type = specimanTypes[Math.floor(Math.random()*specimanTypes.length)];
        //const d = randomDate(new Date(2012, 0, 1), new Date(2013, 0, 1));
        
        const d = new Date((new Date(2012,0,1)).getTime() + Math.random() * ((new Date(2013, 0,1)).getTime() - (new Date(2012, 0, 1)).getTime()));
        patient.DateOfTesting = d.toString();
        patient.Result = resultTypes[Math.floor(Math.random()*resultTypes.length)];
        patient.patientNumber = patientNumber;

        await ctx.stub.putState(email,Buffer.from(JSON.stringify(patient)));

    }

    async dischargeReport(ctx, msg, policy)
    {
        let originalMessage =  Buffer.from(JSON.stringify(msg.toString('ascii'))) 
        let email = originalMessage.email
        let patientNumber = originalMessage.patientNumber
        const patientAsBytes = await ctx.stub.getState(email); // get the car from chaincode state
        if (!patientAsBytes || patientAsBytes.length === 0) {
            return new String(`${patientNumber} does not exist`);
        }

        let patient = JSON.parse(patientAsBytes.toString());
        const Doctors = ['Dr. Pragya', 'Dr. Umang', 'Dr. Dhiraj'];
        const Discharging_consultant = ['Dr. Pratik', 'Dr. Chandrakant', 'Dr. Suraj']

        patient.Practitioner = Doctors[Math.floor(Math.random()*Doctors.length)];
        patient.Discharging_consultant = Discharging_consultant[Math.floor(Math.random()*Discharging_consultant.length)];
        patient.Discharging_Speciality = patient.Doctor_Specialization;
        const regionCode = PhoneNumber.getRegionCodeForCountryCode(91);
        patient.Discharging_Contact = PhoneNumber.getExample(regionCode, 'mobile');

        //const d = randomDate(new Date(2013, 0, 1), new Date(2013, 1, 1));
        //const d2 = randomDate(new Date(2013, 3, 1), new Date(2013, 4, 1));

        //patient.Date_Of_Admission = d.toString();
        let ts = Date.now();
        let date_ob = new Date(ts);
        let date = date_ob.getDate();
        let month = date_ob.getMonth() + 1;
        let year = date_ob.getFullYear();
        
        patient.Date_Of_Discharge = year + "-" + month + "-" + date;

        await ctx.stub.putState(email, Buffer.from(JSON.stringify(patient)));
    }

    async getfunctionKey(ctx, msg, policy)
    {
        //const data = ctx.stub.getTransient();

        const data = await ctx.stub.getSignedProposal();
        return data;

    }

     randomDate (start, end) {
        return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
      }
      
    // "path": "/tmp/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/priv_sk"
    //"path": "/tmp/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem"
    ///tmp/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
}

module.exports = HealthWork;
