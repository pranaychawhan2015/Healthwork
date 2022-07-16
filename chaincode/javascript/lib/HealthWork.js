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
        const doctors = [
            {
                Name: 'Dr. Chandramukhi',
                Speciality: 'consultant',
                Qualification: 'MD,DNB',
                YOE:20,
                Specialization:'CARDIOLOGY',
                Symptoms_Addressed:['Chest pain', 'Dizziness', 'Fainting', 'Numbness', 'Back pain', 'Racing heartbeat', 'Pale gray or blue skin color', 'Dry or persistent cough']
            },
            {
                Name: 'Dr. A Srinivas Raju',
                Speciality: 'consultant',
                Qualification: 'MD, DNB, FSCAI',
                YOE:10,
                Specialization:'CARDIOLOGY',
                Symptoms_Addressed:['Chest pain', 'Dizziness', 'Fainting', 'Numbness', 'Back pain', 'Racing heartbeat', 'Pale gray or blue skin color', 'Dry or persistent cough']
            },
            {
                Name: 'Dr. Johann Christopher',
                Speciality: 'consultant',
                Qualification: 'MD, DNB, ACC, FACC, FICS',
                YOE:16,
                Specialization:'CARDIOLOGY',
                Symptoms_Addressed:['Chest pain', 'Dizziness', 'Fainting', 'Numbness', 'Back pain', 'Racing heartbeat', 'Pale gray or blue skin color', 'Dry or persistent cough']
            },
            {
                Name: 'Dr. Nirmal kumar',
                Speciality: 'consultant',
                Qualification: 'MD,DNB',
                YOE:4,
                Specialization:'CARDIOLOGY',
                Symptoms_Addressed:['Chest pain', 'Dizziness', 'Fainting', 'Numbness', 'Back pain', 'Racing heartbeat', 'Pale gray or blue skin color', 'Dry or persistent cough']
            },
            {
                Name: 'Dr. Santosh Hedau',
                Speciality: 'Renal transaplant & Nephrology',
                Qualification: 'DNB',
                YOE:6,
                Specialization:'NEPHROLOGY',
                Symptoms_Addressed:['Swelling', 'Fatigue', 'Loss of appetite', 'lower back pain']
            },
            {
                Name: 'Dr. Vikranth reddy',
                Speciality: 'HOD & chief consultant nephrologist',
                Qualification: 'ND,DNB,MNAMS',
                YOE:19,
                Specialization:'NEPHROLOGY',
                Symptoms_Addressed:['Swelling', 'Fatigue', 'Loss of appetite', 'lower back pain']
            },
            {
                Name: 'Dr. Ratan Jha',
                Speciality: 'Sr. Nephrologist & Transplant Physician',
                Qualification: 'DM,DNB, MD, DTCD (gold medalist), FISN',
                YOE:30,
                Specialization:'NEPHROLOGY',
                Symptoms_Addressed:['Swelling', 'Fatigue', 'Loss of appetite', 'lower back pain']
            },
            //Speciality=:ecert,Qualification=ND,DNB:ecert,Y.O.E=20,Symptom1=Fatigue:ecert,Symptom2=Swelling
            {
                Name: 'Dr. Cain',
                Speciality: 'Renal transaplant & Nephrology',
                Qualification: 'ND,DNB',
                YOE:20,
                Specialization:'NEPHROLOGY',
                Symptoms_Addressed:['Fatigue', 'Swelling']
            },
            {
                Name: 'Dr. Nikhitha .M',
                Speciality: 'cardilogy, neurology, pulmonology, renal issues, orthopedic concerns, gynecology, dermatology, psychiatry',
                Qualification: 'MBBS',
                YOE:5,
                Specialization:'EMERGENCY & ACUTE CARE',
                Symptoms_Addressed:['chest pain', 'head/neck/spine injuries', 'swelling' ]
            },
            {
                Name: 'Dr.Subash Jain',
                Speciality: 'cardilogy, neurology, pulmonology, renal issues, orthopedic concerns, gynecology, dermatology, psychiatry',
                Qualification: 'MBBS',
                YOE:3,
                Specialization:'EMERGENCY & ACUTE CARE',
                Symptoms_Addressed:['chest pain', 'head/neck/spine injuries', 'swelling' ]
            },
            //Specialization=EMERGENCY & ACUTE CARE:ecert,Email=peer2.org3.example.com:ecert,Speciality=cardilogy,neurology,pulmonology,renal issues,orthopedic concerns,gynecology:ecert,Qualification=MBBS:ecert,Y.O.E=16:ecert
            {
                Name: 'Dr.Vinit Jain',
                Speciality: 'cardilogy,neurology,pulmonology,renal issues,orthopedic concerns,gynecology',
                Qualification: 'MBBS',
                YOE:16,
                Specialization:'EMERGENCY & ACUTE CARE',
                Symptoms_Addressed:['chest pain', 'head/neck/spine injuries', 'swelling' ]
            },
            //Specialization=EMERGENCY & ACUTE CARE:ecert,Email=peer3.org3.example.com:ecert,Speciality=cardilogy,neurology,pulmonology,renal issues,gynecology:ecert,Qualification=MBBS:ecert,Y.O.E=12:ecert,Symptom1=chest pain:ecert,Symptom2=head/neck/spine injuries:ecert,Symptom3=swelling:ecert
            {
                Name: 'Dr.Sunita',
                Speciality: 'cardilogy,neurology,pulmonology,renal issues,gynecology',
                Qualification: 'MBBS',
                YOE:12,
                Specialization:'EMERGENCY & ACUTE CARE',
                Symptoms_Addressed:['chest pain', 'head/neck/spine injuries', 'swelling' ]
            },
            //Role=Doctor:ecert,Email=peer0.org4.example.com:ecert,Specialization=ORTHOPAEDICS:ecert,Speciality=consultant:ecert,Qualification=MBBS,MS:ecert,Y.O.E=4:ecert,Numbness,Symptom1=Swelling:ecert,Symptom2=Joint pain:ecert,Symptom3=lower back pain:ecert,Symptom4=Stiffness:ecert,Symptom5=head/neck/spine injuries:ecert
            {
                Name: 'Dr. BN Prasad',
                Speciality: 'consultant',
                Qualification: 'MBBS,MS',
                YOE:4,
                Specialization:'ORTHOPAEDICS',
                Symptoms_Addressed:['Numbness', 'Swelling', 'Joint pain', 'lower back pain', 'Stiffness', 'head/neck/spine injuries' ]
            },
            {
                Name: 'Dr. K Ratnakar Rao',
                Speciality: 'HOD – Sr. Consultant Joint replacement & Arthoscopic surgery',
                Qualification: 'MBBS,MS',
                YOE:18,
                Specialization:'ORTHOPAEDICS',
                Symptoms_Addressed:['Numbness', 'Swelling', 'Joint pain', 'lower back pain', 'Stiffness', 'head/neck/spine injuries' ]
            },
            {
                Name: 'Dr. Anand Nagarani',
                Speciality: 'consultant orthopedic surgeon',
                Qualification: 'MBBS,MS,Mch Ortho(UK)',
                YOE:17,
                Specialization:'ORTHOPAEDICS',
                Symptoms_Addressed:['Numbness', 'Swelling', 'Joint pain', 'lower back pain', 'Stiffness', 'head/neck/spine injuries' ]
            },
            {
                Name: 'Dr. CR Harish',
                Speciality: 'consultant general & laproscopic surgeon',
                Qualification: 'MS,NIMS',
                YOE:20,
                Specialization:'ORTHOPAEDICS',
                Symptoms_Addressed:['Numbness', 'Swelling', 'Joint pain', 'lower back pain', 'Stiffness', 'head/neck/spine injuries' ]
            }
        ];

        for (let i = 0; i < doctors.length; i++) {
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

    async queryPatient(ctx, email, priv_peer, priv_key, msg) {
        const patientAsBytes = await ctx.stub.getState(email); // get the car from chaincode state
        if (!patientAsBytes || patientAsBytes.length === 0) {
            return new String(`${email} does not exist`);
        }
        console.log(patientAsBytes.toString());
        return patientAsBytes.toString();
    }

    async noop(ctx, data)
    {
        return data;
    }

    async createPatient(ctx, patientNumber, Name, Age ,Departments, Symptoms, Email, Adhar,Emergency_level, priv_peer, priv_key, msg) {
        console.info('============= START : Create Car ===========');

        if(patientNumber == null || Name == null || Email == null  || Adhar == null || Age == null || Departments == null || Symptoms == null || Emergency_level == null)
        {
            return new String("One of the parameters are missing");
        }
        const patient = {
            patientNumber,
            docType: 'patient',
            Name,
            Age,
            Departments,
            Symptoms,
            Email,
            Adhar,
            Organization,
            Emergency_level
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

    async queryAllPatients(ctx, priv_peer, priv_key, msg) {
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

    async queryAllDoctorsForThisSymptom(ctx, symptoms){
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
            if (record.Specialization != null || record.Specialization != undefined){
                    record.Symptoms.forEach(symptom => {
                        if(symptoms.includes(symptom))
                        {
                            allResults.push({ Key: key, Record: record });
                        }
                    });
            } 
            
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

    async changePatientName(ctx, email, patientNumber, newName, priv_peer, priv_key, msg) {
        console.info('============= START : changeCarOwner ===========');

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
    
    async deletePatient(ctx, email, patientNumber, priv_peer, priv_key, msg)
    {
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

    async deleteAllPatients(ctx, priv_peer, priv_key, msg)
    {
        const startKey = '';
        const endKey = '';

        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
                await ctx.stub.deleteState(key);
        }
        
        return JSON.stringify('');
    }

    async testsampleReport(ctx, email, patientNumber, priv_peer, priv_key, msg)
    {
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

    async dischargeReport(ctx, email, patientNumber, priv_peer, priv_key, msg)
    {
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

    async getfunctionKey(ctx, key, priv_peer, priv_key, msg)
    {
        //const data = ctx.stub.getTransient();

        const data = await ctx.stub.getSignedProposal();
        return data;

    }

    async queryAllDoctors(ctx)
    {

    }
    
     randomDate (start, end) {
        return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
      }
      
    // "path": "/tmp/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/priv_sk"
    //"path": "/tmp/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem"
    ///tmp/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
}

module.exports = HealthWork;
