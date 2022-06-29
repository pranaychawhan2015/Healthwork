/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const HealthWork = require('./lib/HealthWork');
const Student = require('./lib/Student');

module.exports.HealthWork = HealthWork;
module.exports.Student = Student;
module.exports.contracts = [ HealthWork,Student ];
