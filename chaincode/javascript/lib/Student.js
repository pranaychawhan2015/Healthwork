'use strict'

const { Contract } = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;
//const peerIdentity = require('fa');
const fabric_shim_api = require('fabric-shim-api') 
const fabric_shim = require('fabric-shim')

class Student extends Contract
{
    async addStudent(ctx, student)
    {
        await ctx.stub.putState(student.email, JSON.parse(student.toString()));
    }
    
    async editStudent(ctx, email, student)
    {
        existingStudent = await ctx.stub.getState(email);
        if(student.email != undefined || student.email != null)
        {
            existingStudent.email = student.email;
        }
        if(student.mobile != undefined || student.mobile != null)
        {
            existingStudent.mobile = student.mobile;
        }
        if(student.firstName != undefined || student.firstName != null)
        {
            existingStudent.firstName = student.firstName;
        }
        if(student.lastName != undefined || student.lastName != null)
        {
            existingStudent.lastName = student.lastName;
        }
        if(student.address != undefined || student.address != null)
        {
            existingStudent.address = student.address;
        }
        
        ctx.stub.putState(existingStudent.email, JSON.parse(existingStudent.toString()));
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
         let student =  await ctx.stub.getState(email);

         return JSON.stringify(student);
    }

    
}

module.exports = Student;