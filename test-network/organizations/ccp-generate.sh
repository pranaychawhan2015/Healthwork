#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function one_line_priv {
    echo "`awk 'NF {printf $0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    local CERT0=$(one_line_pem $7)
    local CERT1=$(one_line_pem $8)
    local KEY0=$(one_line_pem $9)
    local KEY1=$(one_line_pem ${10})
    local CERT2=$(one_line_pem ${11})
    local CERT3=$(one_line_pem ${12})
    local KEY2=$(one_line_pem ${13})
    local KEY3=$(one_line_pem ${14})
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s#\${CERT0}#$CERT0#" \
        -e "s#\${CERT1}#$CERT1#" \
        -e "s#\${KEY0}#$KEY0#" \
        -e "s#\${KEY1}#$KEY1#" \
        -e "s#\${CERT2}#$CERT2#" \
        -e "s#\${CERT3}#$CERT3#" \
        -e "s#\${KEY2}#$KEY2#" \
        -e "s#\${KEY3}#$KEY3#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    local CERT0=$(one_line_pem $7)
    local CERT1=$(one_line_pem $8)
    local KEY0=$(one_line_pem $9)
    local KEY1=$(one_line_pem ${10})
    local CERT2=$(one_line_pem ${11})
    local CERT3=$(one_line_pem ${12})
    local KEY2=$(one_line_pem ${13})
    local KEY3=$(one_line_pem ${14})
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s#\${CERT0}#$CERT0#" \
        -e "s#\${CERT1}#$CERT1#" \
        -e "s#\${KEY0}#$KEY0#" \
        -e "s#\${KEY1}#$KEY1#" \
        -e "s#\${CERT2}#$CERT2#" \
        -e "s#\${CERT3}#$CERT3#" \
        -e "s#\${KEY2}#$KEY2#" \
        -e "s#\${KEY3}#$KEY3#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

CAORG=ORG-1-CARDIOLOGY
ORG=ORG-1-CARDIOLOGY
P0PORT=7051
P1PORT=8051
P2PORT=8053
P3PORT=8055
CAPORT=7054
PEERPEM=organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/tlsca/tlsca.ORG-1-CARDIOLOGY.example.com-cert.pem
CAPEM=organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/ca/ca.ORG-1-CARDIOLOGY.example.com-cert.pem
CERT0=organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/msp/signcerts/cert.pem
CERT1=organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/msp/signcerts/cert.pem
CERT2=organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/msp/signcerts/cert.pem
CERT3=organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/msp/signcerts/cert.pem
KEY0=organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/msp/keystore/priv_sk
KEY1=organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/msp/keystore/priv_sk
KEY2=organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/msp/keystore/priv_sk
KEY3=organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/msp/keystore/priv_sk


echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1 $CERT2 $CERT3 $KEY2 $KEY3)" > organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/connection-ORG-1-CARDIOLOGY.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1 $CERT2 $CERT3 $KEY2 $KEY3)" > organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/connection-ORG-1-CARDIOLOGY.yaml

CAORG=ORG-2-NEPHROLOGY
ORG=ORG-2-NEPHROLOGY
P0PORT=9051
P1PORT=12051
P2PORT=12053
P3PORT=12055
CAPORT=8054
PEERPEM=organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/tlsca/tlsca.ORG-2-NEPHROLOGY.example.com-cert.pem
CAPEM=organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/ca/ca.ORG-2-NEPHROLOGY.example.com-cert.pem
CERT0=organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/msp/signcerts/cert.pem
CERT1=organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/msp/signcerts/cert.pem
CERT2=organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/msp/signcerts/cert.pem
CERT3=organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/msp/signcerts/cert.pem
KEY0=organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/msp/keystore/priv_sk
KEY1=organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/msp/keystore/priv_sk
KEY2=organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/msp/keystore/priv_sk
KEY3=organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.ORG-2-NEPHROLOGY.example.com/msp/keystore/priv_sk

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1 $CERT2 $CERT3 $KEY2 $KEY3)" > organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/connection-ORG-2-NEPHROLOGY.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1 $CERT2 $CERT3 $KEY2 $KEY3)" > organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/connection-ORG-2-NEPHROLOGY.yaml

CAORG=ORG-3-EMERGENCY
ORG=ORG-3-EMERGENCY
P0PORT=10051
P1PORT=13051
P2PORT=13053
P3PORT=13055
CAPORT=10054
PEERPEM=organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/tlsca/tlsca.ORG-3-EMERGENCY.example.com-cert.pem
CAPEM=organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/ca/ca.ORG-3-EMERGENCY.example.com-cert.pem
CERT0=organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/msp/signcerts/cert.pem
CERT1=organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/msp/signcerts/cert.pem
CERT2=organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/msp/signcerts/cert.pem
CERT3=organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/msp/signcerts/cert.pem
KEY0=organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/msp/keystore/priv_sk
KEY1=organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/msp/keystore/priv_sk
KEY2=organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCY.example.com/msp/keystore/priv_sk
KEY3=organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/msp/keystore/priv_sk

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1 $CERT2 $CERT3 $KEY2 $KEY3 )" > organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/connection-ORG-3-EMERGENCY.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1 $CERT2 $CERT3 $KEY2 $KEY3)" > organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/connection-ORG-3-EMERGENCY.yaml

CAORG=ORG-4-ORTHOPAEDICS
ORG=ORG-4-ORTHOPAEDICS
P0PORT=11051
P1PORT=14051
P2PORT=14053
P3PORT=14055
CAPORT=11054
PEERPEM=organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/tlsca/tlsca.ORG-4-ORTHOPAEDICS.example.com-cert.pem
CAPEM=organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/ca/ca.ORG-4-ORTHOPAEDICS.example.com-cert.pem
CERT0=organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/msp/signcerts/cert.pem
CERT1=organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/msp/signcerts/cert.pem
CERT2=organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/msp/signcerts/cert.pem
CERT3=organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/msp/signcerts/cert.pem
KEY0=organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/msp/keystore/priv_sk
KEY1=organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/msp/keystore/priv_sk
KEY2=organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/msp/keystore/priv_sk
KEY3=organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/msp/keystore/priv_sk

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1 $CERT2 $CERT3 $KEY2 $KEY3)" > organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/connection-ORG-4-ORTHOPAEDICS.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1 $CERT2 $CERT3 $KEY2 $KEY3)" > organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/connection-ORG-4-ORTHOPAEDICS.yaml
