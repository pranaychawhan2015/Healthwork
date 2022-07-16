#!/bin/bash

function createORG-1-CARDIOLOGY() {
  infoln "Enrolling the CA admin for Cardiology"
  mkdir -p organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ORG-1-CARDIOLOGY --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ORG-1-CARDIOLOGY.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ORG-1-CARDIOLOGY.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ORG-1-CARDIOLOGY.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ORG-1-CARDIOLOGY.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=Cardiology:ecert,Email=peer0.ORG-1-CARDIOLOGY.example.com:ecert,Speciality=consultant:ecert,Qualification1=MD:ecert,Qualification2=DNB:ecert,Y.O.E=20:ecert,Symptom1=Chest pain:ecert,Symptom2=Dizziness:ecert,Symptom3=Fainting:ecert,Symptom4=Numbness:ecert,Symptom5=Back\tpain:ecert,Symptom6=Racing\theartbeat:ecert,Symptom7=Pale\tgray\tor\tblue\tskin\tcolor:ecert,Symptom8=Dry\tor\tpersistent\tcough:ecert' --caname ORG-1-CARDIOLOGY --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Email=peer1.ORG-1-CARDIOLOGY.example.com:ecert,Specialization=Cardiology:ecert,Speciality=consultant:ecert,Qualification1=MD:ecert,Qualification2=DNB:ecert,Qualification3=FSCAI:ecert,Y.O.E=10:ecert,Symptom1=Chest\tpain:ecert,Symptom2=Dizziness:ecert,Symptom3=Fainting:ecert,Symptom4=Numbness:ecert,Symptom5=Back\tpain:ecert' --caname ORG-1-CARDIOLOGY --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer2"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=Cardiology:ecert,Email=peer2.ORG-1-CARDIOLOGY.example.com:ecert,Speciality=Consultant:ecert,Qualification1=MD:ecert,Qualification2=DNB:ecert,Qualification3=ACC:ecert,Qualification4=FACC:ecert,Qualification5=FICS:ecert,Y.O.E=16:ecert,Symptom1=Chest\tpain:ecert,Symptom2=Dizziness:ecert,Symptom3=Fainting:ecert,Symptom4=Numbness:ecert,Symptom5=Back\tpain:ecert,Symptom6=pale\tgray\tor\tblue\tskin:ecert,Symptom7=racing\theartbeat:ecert,Symptom8=dry\tor\tpersistent\tcough:ecert' --caname ORG-1-CARDIOLOGY --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer3"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Email=peer3.ORG-1-CARDIOLOGY.example.com:ecert,Specialization=Cardiology:ecert,Speciality=Consultant:ecert,Qualification1=MD:ecert,Qualification2=DNB:ecert,Symptom1=Chest\tpain:ecert,Symptom2=Dizziness:ecert,Symptom3=Fainting:ecert,Symptom4=Numbness:ecert,Symptom5=Back\tpain:ecert,Y.O.E=4:ecert' --caname ORG-1-CARDIOLOGY --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/nul


  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ORG-1-CARDIOLOGY --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ORG-1-CARDIOLOGY --id.name ORG-1-CARDIOLOGYadmin --id.secret ORG-1-CARDIOLOGYadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ORG-1-CARDIOLOGY -M ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/msp --csr.hosts peer0.ORG-1-CARDIOLOGY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/msp/config.yaml
  mkdir ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/plugins/plugin.so
  mkdir ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/config 
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/msp/keystore/priv_sk
  cp '/home/cps16/Documents/Medical_Records/config/core copy 2.yaml' ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/config/core.yaml


  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ORG-1-CARDIOLOGY -M ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/msp --csr.hosts peer1.ORG-1-CARDIOLOGY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/msp/config.yaml
    mkdir ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/plugins/plugin.so
    mkdir ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/config
   
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/msp/keystore/priv_sk
  cp '/home/cps16/Documents/Medical_Records/config/core copy 3.yaml' ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/config/core.yaml


  infoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7054 --caname ORG-1-CARDIOLOGY -M ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/msp --csr.hosts peer2.ORG-1-CARDIOLOGY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/msp/config.yaml
    mkdir ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/plugins/plugin.so
    mkdir ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/config
   
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/msp/keystore/priv_sk
  cp '/home/cps16/Documents/Medical_Records/config/core copy 4.yaml' ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/config/core.yaml

  infoln "Generating the peer3 msp"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:7054 --caname ORG-1-CARDIOLOGY -M ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/msp --csr.hosts peer3.ORG-1-CARDIOLOGY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/msp/config.yaml
    mkdir ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/plugins/plugin.so
    mkdir ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/config
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/msp/keystore/priv_sk
  cp '/home/cps16/Documents/Medical_Records/config/core copy 5.yaml' ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/config/core.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054  --caname ORG-1-CARDIOLOGY -M ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/tls --enrollment.profile tls --csr.hosts peer0.ORG-1-CARDIOLOGY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/tlsca/tlsca.ORG-1-CARDIOLOGY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/ca/ca.ORG-1-CARDIOLOGY.example.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054  --caname ORG-1-CARDIOLOGY -M ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/tls --enrollment.profile tls --csr.hosts peer1.ORG-1-CARDIOLOGY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/tlsca/tlsca.ORG-1-CARDIOLOGY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/ca/ca.ORG-1-CARDIOLOGY.example.com-cert.pem

  infoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7054 --caname ORG-1-CARDIOLOGY  -M ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/tls --enrollment.profile tls --csr.hosts peer2.ORG-1-CARDIOLOGY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/tlsca/tlsca.ORG-1-CARDIOLOGY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/ca/ca.ORG-1-CARDIOLOGY.example.com-cert.pem

  infoln "Generating the peer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:7054  --caname ORG-1-CARDIOLOGY -M ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/tls --enrollment.profile tls --csr.hosts peer3.ORG-1-CARDIOLOGY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/tlsca/tlsca.ORG-1-CARDIOLOGY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/ca/ca.ORG-1-CARDIOLOGY.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ORG-1-CARDIOLOGY -M ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/users/User1@ORG-1-CARDIOLOGY.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/users/User1@ORG-1-CARDIOLOGY.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://ORG-1-CARDIOLOGYadmin:ORG-1-CARDIOLOGYadminpw@localhost:7054 --caname ORG-1-CARDIOLOGY -M ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/users/Admin@ORG-1-CARDIOLOGY.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-1-CARDIOLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/users/Admin@ORG-1-CARDIOLOGY.example.com/msp/config.yaml
}

function createORG-2-NEPHROLOGY() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ORG-2-NEPHROLOGY --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ORG-2-NEPHROLOGY.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ORG-2-NEPHROLOGY.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ORG-2-NEPHROLOGY.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ORG-2-NEPHROLOGY.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=NEPHROLOGY:ecert,Email=peer0.ORG-2-NEPHROLOGY.example.com:ecert,Speciality=Renal\ttransaplant\t&\tNephrology:ecert,Qualification=DNB:ecert,Y.O.E=6:ecert,Symptom1=Swelling:ecert,Symptom2=Fatigue:ecert,Symptom3=Loss\tof\tappetite:ecert,Symptom4=lower\tback\tpain:ecert' --caname ORG-2-NEPHROLOGY --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=NEPHROLOGY:ecert,Email=peer1.ORG-2-NEPHROLOGY.example.com:ecert,Speciality=HOD\t&\tchief\tconsultant\tnephrologist:ecert,Qualification1=ND:ecert,Qualification2=DNB:ecert,Qualification3=MNAMS:ecert,Y.O.E=19:ecert,Symptom1=Swelling:ecert,Symptom2=Fatigue:ecert,Symptom3=Loss\tof\tappetite:ecert,Symptom4=lower\tback\tpain:ecert' --caname ORG-2-NEPHROLOGY --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer2"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=NEPHROLOGY:ecert,Email=peer2.ORG-2-NEPHROLOGY.example.com:ecert,Speciality=Sr.\tNephrologist\t&\tTransplant\tPhysician:ecert,Qualification1=DM:ecert,Qualification2=DNB:ecert,Qualification3=MD:ecert,Qualification4=DTCD(gold\tmedalist):ecert,Qualification5=FISN:ecert,Y.O.E=30:ecert,Symptom1=Swelling:ecert,Symptom2=Fatigue:ecert,Symptom3=Loss\tof\tappetite:ecert,Symptom4=lower\tback\tpain:ecert' --caname ORG-2-NEPHROLOGY --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer3"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=NEPHROLOGY:ecert,Email=peer3.ORG-2-NEPHROLOGY.example.com:ecert,Speciality=Renal\ttransaplant\t&\tNephrology:ecert,Qualification1=ND:ecert,Qualification2=DNB:ecert,Y.O.E=20,Symptom1=Fatigue:ecert,Symptom2=Swelling' --caname ORG-2-NEPHROLOGY --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null


  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ORG-2-NEPHROLOGY --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ORG-2-NEPHROLOGY --id.name ORG-2-NEPHROLOGYadmin --id.secret ORG-2-NEPHROLOGYadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ORG-2-NEPHROLOGY -M ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/msp --csr.hosts peer0.ORG-2-NEPHROLOGY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/msp/config.yaml
  mkdir ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/plugins/plugin.so
   
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/msp/keystore/priv_sk


  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ORG-2-NEPHROLOGY -M ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/msp --csr.hosts peer1.ORG-2-NEPHROLOGY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/msp/config.yaml
  mkdir ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/plugins/plugin.so
   
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/msp/keystore/priv_sk

  infoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054 --caname ORG-2-NEPHROLOGY -M ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/msp --csr.hosts peer2.ORG-2-NEPHROLOGY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/msp/config.yaml
  mkdir ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/plugins/plugin.so
  
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/msp/keystore/priv_sk

  infoln "Generating the peer3 msp"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:8054 --caname ORG-2-NEPHROLOGY -M ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/msp --csr.hosts peer3.ORG-2-NEPHROLOGY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/msp/config.yaml
  mkdir ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/plugins/plugin.so
   
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/msp/keystore/priv_sk

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ORG-2-NEPHROLOGY  -M ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/tls --enrollment.profile tls --csr.hosts peer0.ORG-2-NEPHROLOGY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/tlsca/tlsca.ORG-2-NEPHROLOGY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/ca/ca.ORG-2-NEPHROLOGY.example.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ORG-2-NEPHROLOGY  -M ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/tls --enrollment.profile tls --csr.hosts peer1.ORG-2-NEPHROLOGY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/tlsca/tlsca.ORG-2-NEPHROLOGY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/ca/ca.ORG-2-NEPHROLOGY.example.com-cert.pem

  infoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054  --caname ORG-2-NEPHROLOGY -M ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/tls --enrollment.profile tls --csr.hosts peer2.ORG-2-NEPHROLOGY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/tlsca/tlsca.ORG-2-NEPHROLOGY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/ca/ca.ORG-2-NEPHROLOGY.example.com-cert.pem

  infoln "Generating the peer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:8054 --caname ORG-2-NEPHROLOGY  -M ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/tls --enrollment.profile tls --csr.hosts peer3.ORG-2-NEPHROLOGY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/tlsca/tlsca.ORG-2-NEPHROLOGY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/ca/ca.ORG-2-NEPHROLOGY.example.com-cert.pem



  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ORG-2-NEPHROLOGY -M ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/users/User1@ORG-2-NEPHROLOGY.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/users/User1@ORG-2-NEPHROLOGY.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://ORG-2-NEPHROLOGYadmin:ORG-2-NEPHROLOGYadminpw@localhost:8054 --caname ORG-2-NEPHROLOGY -M ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/users/Admin@ORG-2-NEPHROLOGY.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-2-NEPHROLOGY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/users/Admin@ORG-2-NEPHROLOGY.example.com/msp/config.yaml
}

function createORG-3-EMERGENCY() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ORG-3-EMERGENCY --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ORG-3-EMERGENCY.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ORG-3-EMERGENCY.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ORG-3-EMERGENCY.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ORG-3-EMERGENCY.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=EMERGENCY:ecert,Email=peer0.ORG-3-EMERGENCY.example.com:ecert,Symptom1=chest\tpain:ecert,Symptom2=head/neck/spine\tinjuries:ecert,Symptom3=swelling:ecert,Speciality=emergency\tcare:ecert,Qualification=MBBS:ecert,Y.O.E=5:ecert' --caname ORG-3-EMERGENCY --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specializatipn=EMERGENCY:ecert,Speciality=emergency\tcare:ecert,Symptom1=chest\tpain:ecert,Symptom2=head/neck/spine\tinjuries:ecert,Symptom3=swelling:ecert,Email=peer1.ORG-3-EMERGENCY.example.com:ecert,Y.O.E=3:ecert,Qualification=MBBS:ecert' --caname ORG-3-EMERGENCY --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer2"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=EMERGENCY:ecert,Email=peer2.ORG-3-EMERGENCY.example.com:ecert,Speciality=emergency\tcare:ecert,Qualification=MBBS:ecert,Y.O.E=16:ecert,Symptom1=chest\tpain:ecert,Symptom2=head/neck/spine\tinjuries:ecert,Symptom3=swelling:ecert' --caname ORG-3-EMERGENCY --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer3"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=EMERGENCY:ecert,Email=peer3.ORG-3-EMERGENCY.example.com:ecert,Speciality=emergency\tcare:ecert,Qualification=MBBS:ecert,Y.O.E=12:ecert,Symptom1=chest\tpain:ecert,Symptom2=head/neck/spine\tinjuries:ecert,Symptom3=swelling:ecert' --caname ORG-3-EMERGENCY --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ORG-3-EMERGENCY --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ORG-3-EMERGENCY --id.name ORG-3-EMERGENCYadmin --id.secret ORG-3-EMERGENCYadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ORG-3-EMERGENCY -M ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/msp --csr.hosts peer0.ORG-3-EMERGENCY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/msp/config.yaml
    mkdir ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/plugins/plugin.so
  
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/msp/keystore/priv_sk

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ORG-3-EMERGENCY -M ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/msp --csr.hosts peer1.ORG-3-EMERGENCY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/msp/config.yaml
      mkdir ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/plugins/plugin.so
 cp $(find ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/msp/keystore -name "*_sk") ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/msp/keystore/priv_sk
  
  infoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:10054 --caname ORG-3-EMERGENCY -M ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/msp --csr.hosts peer2.ORG-3-EMERGENCY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/msp/config.yaml
      mkdir ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/plugins/plugin.so
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/msp/keystore/priv_sk

  infoln "Generating the peer3 msp"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:10054 --caname ORG-3-EMERGENCY -M ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/msp --csr.hosts peer3.ORG-3-EMERGENCY.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/msp/config.yaml
      mkdir ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/plugins/plugin.so
   
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/msp/keystore/priv_sk
  
  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054  --caname ORG-3-EMERGENCY -M ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/tls --enrollment.profile tls --csr.hosts peer0.ORG-3-EMERGENCY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/tlsca/tlsca.ORG-3-EMERGENCY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/ca/ca.ORG-3-EMERGENCY.example.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054  --caname ORG-3-EMERGENCY -M ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/tls --enrollment.profile tls --csr.hosts peer1.ORG-3-EMERGENCY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/tlsca/tlsca.ORG-3-EMERGENCY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/ca/ca.ORG-3-EMERGENCY.example.com-cert.pem

  infoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:10054  --caname ORG-3-EMERGENCY -M ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/tls --enrollment.profile tls --csr.hosts peer2.ORG-3-EMERGENCY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/tlsca/tlsca.ORG-3-EMERGENCY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/ca/ca.ORG-3-EMERGENCY.example.com-cert.pem

   infoln "Generating the peer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:10054 --caname ORG-3-EMERGENCY  -M ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/tls --enrollment.profile tls --csr.hosts peer3.ORG-3-EMERGENCY.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/tlsca/tlsca.ORG-3-EMERGENCY.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/ca/ca.ORG-3-EMERGENCY.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ORG-3-EMERGENCY -M ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/users/User1@ORG-3-EMERGENCY.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/users/User1@ORG-3-EMERGENCY.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://ORG-3-EMERGENCYadmin:ORG-3-EMERGENCYadminpw@localhost:10054 --caname ORG-3-EMERGENCY -M ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/users/Admin@ORG-3-EMERGENCY.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-3-EMERGENCY/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/users/Admin@ORG-3-EMERGENCY.example.com/msp/config.yaml
}

function createORG-4-ORTHOPAEDICS() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ORG-4-ORTHOPAEDICS --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ORG-4-ORTHOPAEDICS.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ORG-4-ORTHOPAEDICS.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ORG-4-ORTHOPAEDICS.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ORG-4-ORTHOPAEDICS.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Email=peer0.ORG-4-ORTHOPAEDICS.example.com:ecert,Specialization=ORTHOPAEDICS:ecert,Speciality=consultant:ecert,Qualification1=MBBS:ecert,Qualification2=MS:ecert,Y.O.E=4:ecert,Symptom1=Swelling:ecert,Symptom2=Joint\tpain:ecert,Symptom3=lower\tback\tpain:ecert,Symptom4=Stiffness:ecert,Symptom5=head/neck/spine\tinjuries:ecert,Symptom6=Numbness:ecert' --caname ORG-4-ORTHOPAEDICS --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --enrollment.type x509  --id.attrs 'Role=Doctor:ecert,Specialization=ORTHOPAEDICS:ecert,Email=peer1.ORG-4-ORTHOPAEDICS.example.com:ecert,Symptom1=Swelling:ecert,Symptom2=Joint\tpain:ecert,Symptom3=lower\tback\tpain:ecert,Symptom4=Stiffness:ecert,Symptom5=head/neck/spine\tinjuries:ecert,Speciality=HOD\t-\tSr.\tConsultant\tJoint\treplacement\t&\tArthoscopic\tsurgery:ecert,Qualification1=MBBS:ecert,Qualification2=MS:ecert,Y.O.E=18' --caname ORG-4-ORTHOPAEDICS --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer2"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Email=peer2.ORG-4-ORTHOPAEDICS.example.com:ecert,Symptom1=Swelling:ecert,Symptom2=Joint\tpain:ecert,Symptom3=lower\tback\tpain:ecert,Symptom4=Stiffness:ecert,Symptom5=head/neck/spine\tinjuries:ecert,Specialization=ORTHOPAEDICS:ecert,Speciality=consultant\torthopedic\tsurgeon:ecert,Qualification1=MBBS:ecert,Qualification2=MS:ecert,Qualification3=Mch\tOrtho(UK):ecert,Y.O.E=17:ecert' --caname ORG-4-ORTHOPAEDICS --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer3"
  set -x
  fabric-ca-client register --enrollment.type x509  --id.attrs 'Role=Doctor:ecert,Specialization=ORTHOPAEDICS:ecert,Email=peer3.ORG-4-ORTHOPAEDICS.example.com:ecert,Symptom1=Swelling:ecert,Symptom2=Joint\tpain:ecert,Symptom3=lower\tback\tpain:ecert,Symptom4=Stiffness:ecert,Symptom5=head/neck/spine\tinjuries:ecert,Y.O.E=20:ecert,Qualification1=MS:ecert,Qualification2=NIMS:ecert,Speciality=consultant\tgeneral\t&\tlaproscopic\tsurgeon:ecert' --caname ORG-4-ORTHOPAEDICS --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ORG-4-ORTHOPAEDICS --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ORG-4-ORTHOPAEDICS --id.name ORG-4-ORTHOPAEDICSadmin --id.secret ORG-4-ORTHOPAEDICSadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ORG-4-ORTHOPAEDICS -M ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/msp --csr.hosts peer0.ORG-4-ORTHOPAEDICS.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml
      mkdir ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/plugins/plugin.so
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/msp/keystore/priv_sk

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:11054 --caname ORG-4-ORTHOPAEDICS -M ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/msp --csr.hosts peer1.ORG-4-ORTHOPAEDICS.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml
        mkdir ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/plugins/plugin.so

  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/msp/keystore/priv_sk
  
  infoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:11054 --caname ORG-4-ORTHOPAEDICS -M ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/msp --csr.hosts peer2.ORG-4-ORTHOPAEDICS.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml
        mkdir ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/plugins/plugin.so
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/msp/keystore/priv_sk

  infoln "Generating the peer3 msp"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:11054 --caname ORG-4-ORTHOPAEDICS -M ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/msp --csr.hosts peer3.ORG-4-ORTHOPAEDICS.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml
  mkdir ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/plugins
  cp /home/cps16/Documents/go-plugin-fabric/plugin.so ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/plugins/plugin.so
  cp "$(find ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/msp/keystore/priv_sk

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054  --caname ORG-4-ORTHOPAEDICS -M ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/tls --enrollment.profile tls --csr.hosts peer0.ORG-4-ORTHOPAEDICS.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/tlsca/tlsca.ORG-4-ORTHOPAEDICS.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/ca/ca.ORG-4-ORTHOPAEDICS.example.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:11054 --caname ORG-4-ORTHOPAEDICS  -M ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/tls --enrollment.profile tls --csr.hosts peer1.ORG-4-ORTHOPAEDICS.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/tlsca/tlsca.ORG-4-ORTHOPAEDICS.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/ca/ca.ORG-4-ORTHOPAEDICS.example.com-cert.pem

  infoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:11054  --caname ORG-4-ORTHOPAEDICS -M ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/tls --enrollment.profile tls --csr.hosts peer2.ORG-4-ORTHOPAEDICS.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/tlsca/tlsca.ORG-4-ORTHOPAEDICS.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/ca/ca.ORG-4-ORTHOPAEDICS.example.com-cert.pem

  infoln "Generating the peer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:11054 --caname ORG-4-ORTHOPAEDICS  -M ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/tls --enrollment.profile tls --csr.hosts peer3.ORG-4-ORTHOPAEDICS.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/tlsca/tlsca.ORG-4-ORTHOPAEDICS.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/ca/ca.ORG-4-ORTHOPAEDICS.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ORG-4-ORTHOPAEDICS -M ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/users/User1@ORG-4-ORTHOPAEDICS.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/users/User1@ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://ORG-4-ORTHOPAEDICSadmin:ORG-4-ORTHOPAEDICSadminpw@localhost:11054 --caname ORG-4-ORTHOPAEDICS -M ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/users/Admin@ORG-4-ORTHOPAEDICS.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ORG-4-ORTHOPAEDICS/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/users/Admin@ORG-4-ORTHOPAEDICS.example.com/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Registering orderer 1"
  set -x
  fabric-ca-client register --id.attrs 'Role=Admin:ecert'  --caname ca-orderer --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer 2"
  set -x
  fabric-ca-client register --id.attrs 'Role=Admin:ecert'  --caname ca-orderer --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer 3"
  set -x
  fabric-ca-client register --id.attrs 'Role=Admin:ecert'  --caname ca-orderer --id.name orderer3 --id.secret orderer3pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer 1 msp"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp --csr.hosts orderer1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer 2 msp"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer 3 msp"
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/config.yaml
  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml
  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml


  infoln "Generating the orderer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls --enrollment.profile tls --csr.hosts orderer1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the orderer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}
