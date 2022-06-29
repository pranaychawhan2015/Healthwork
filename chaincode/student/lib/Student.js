'use strict'

const { Contract } = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;
//const peerIdentity = require('fa');
const fabric_shim_api = require('fabric-shim-api') 
const fabric_shim = require('fabric-shim')

class Student extends Contract
{
    async addStudent(ctx, email, address, firstName, lastName, mobile, city)
    {
        let student = {
            email,
            address,
            firstName,
            lastName,
            mobile,
            city
        };
        await ctx.stub.putState(email, Buffer.from(JSON.stringify(student)));
    }
    
    async editStudent(ctx, email, mobile, address, firstName, lastName, city)
    {
        const studentAsBytes = await ctx.stub.getState(email); // get the car from chaincode state
        if (!studentAsBytes || studentAsBytes.length === 0) {
            return new String(`${email} does not exist`);
        }
        const existingStudent = JSON.parse(studentAsBytes.toString());
        
        if(mobile != undefined || mobile != null)
        {
            existingStudent.mobile = mobile;
        }
        if(firstName != undefined || firstName != null)
        {
            existingStudent.firstName = firstName;
        }
        if(lastName != undefined || lastName != null)
        {
            existingStudent.lastName = lastName;
        }
        if(address != undefined || address != null)
        {
            existingStudent.address = address;
        }
        if(city != undefined || city != null)
        {
            existingStudent.city = city;
        }
        
        ctx.stub.putState(email, Buffer,from(JSON.stringify(existingStudent)));
    }

    async queryAllStudents(ctx) {
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
        console.info(allResults);
        return JSON.stringify(allResults);
    }

    async queryStudent(ctx, email)
    {
         let student = await ctx.stub.getState(email);

         return student.toString();
    }

    
}

module.exports = Student;