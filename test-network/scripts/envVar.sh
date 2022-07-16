#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export ORDERER_CA2=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export ORDERER_CA3=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

export PEER0_ORG-1-CARDIOLOGY_CA=${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer0.ORG-1-CARDIOLOGY.example.com/tls/ca.crt
export PEER0_ORG-2-NEPHROLOGY_CA=${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer0.ORG-2-NEPHROLOGY.example.com/tls/ca.crt
export PEER0_ORG-3-EMERGENCY_CA=${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer0.ORG-3-EMERGENCY.example.com/tls/ca.crt
export PEER0_ORG-4-ORTHOPAEDICS_CA=${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer0.ORG-4-ORTHOPAEDICS.example.com/tls/ca.crt

export PEER1_ORG-1-CARDIOLOGY_CA=${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer1.ORG-1-CARDIOLOGY.example.com/tls/ca.crt
export PEER1_ORG-2-NEPHROLOGY_CA=${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer1.ORG-2-NEPHROLOGY.example.com/tls/ca.crt
export PEER1_ORG-3-EMERGENCY_CA=${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer1.ORG-3-EMERGENCY.example.com/tls/ca.crt
export PEER1_ORG-4-ORTHOPAEDICS_CA=${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer1.ORG-4-ORTHOPAEDICS.example.com/tls/ca.crt

export PEER2_ORG-1-CARDIOLOGY_CA=${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer2.ORG-1-CARDIOLOGY.example.com/tls/ca.crt
export PEER2_ORG-2-NEPHROLOGY_CA=${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer2.ORG-2-NEPHROLOGY.example.com/tls/ca.crt
export PEER2_ORG-3-EMERGENCY_CA=${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer2.ORG-3-EMERGENCYg3.example.com/tls/ca.crt
export PEER2_ORG-4-ORTHOPAEDICS_CA=${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer2.ORG-4-ORTHOPAEDICS.example.com/tls/ca.crt

export PEER3_ORG-1-CARDIOLOGY_CA=${PWD}/organizations/peerOrganizations/ORG-1-CARDIOLOGY.example.com/peers/peer3.ORG-1-CARDIOLOGY.example.com/tls/ca.crt
export PEER3_ORG-2-NEPHROLOGY_CA=${PWD}/organizations/peerOrganizations/ORG-2-NEPHROLOGY.example.com/peers/peer3.oORG-2-NEPHROLOGYrg2.example.com/tls/ca.crt
export PEER3_ORG-3-EMERGENCY_CA=${PWD}/organizations/peerOrganizations/ORG-3-EMERGENCY.example.com/peers/peer3.ORG-3-EMERGENCY.example.com/tls/ca.crt
export PEER3_ORG-4-ORTHOPAEDICS_CA=${PWD}/organizations/peerOrganizations/ORG-4-ORTHOPAEDICS.example.com/peers/peer3.ORG-4-ORTHOPAEDICS.example.com/tls/ca.crt

# Set envionment variables for the peer org
setGlobals() {
  local USING_ORG=""
  local PEER=$2
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG == "ORG-1-CARDIOLOGY" ] || [ $USING_ORG == "ORG-2-NEPHROLOGY" ] || [ $USING_ORG == "ORG-3-EMERGENCY" ] || [ $USING_ORG == "ORG-4-ORTHOPAEDICS" ]; then
    export CORE_PEER_LOCALMSPID="${USING_ORG}"
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/${USING_ORG}.example.com/users/Admin@${USING_ORG}.example.com/msp
  fi

  if [ $USING_ORG == "ORG-1-CARDIOLOGY" ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG-1-CARDIOLOGY_CA}
      export CORE_PEER_ADDRESS=localhost:7051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER1_ORG-1-CARDIOLOGY_CA}
      export CORE_PEER_ADDRESS=localhost:8051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER2_ORG-1-CARDIOLOGY_CA}
      export CORE_PEER_ADDRESS=localhost:8053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER3_ORG-1-CARDIOLOGY_CA}
      export CORE_PEER_ADDRESS=localhost:8055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG == "ORG-2-NEPHROLOGY" ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG-2-NEPHROLOGY_CA}
      export CORE_PEER_ADDRESS=localhost:9051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER1_ORG-2-NEPHROLOGY_CA}
      export CORE_PEER_ADDRESS=localhost:12051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER2_ORG-2-NEPHROLOGY_CA}
      export CORE_PEER_ADDRESS=localhost:12053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER3_ORG-2-NEPHROLOGY_CA}
      export CORE_PEER_ADDRESS=localhost:12055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG == "ORG-3-EMERGENCY" ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG-3-EMERGENCY_CA}
      export CORE_PEER_ADDRESS=localhost:10051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER1_ORG-3-EMERGENCY_CA}
      export CORE_PEER_ADDRESS=localhost:13051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER2_ORG-3-EMERGENCY_CA}
      export CORE_PEER_ADDRESS=localhost:13053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER3_ORG-3-EMERGENCY_CA}
      export CORE_PEER_ADDRESS=localhost:13055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG == "ORG-4-ORTHOPAEDICS" ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG-4-ORTHOPAEDICS_CA}
      export CORE_PEER_ADDRESS=localhost:11051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER1_ORG-4-ORTHOPAEDICS_CA}
      export CORE_PEER_ADDRESS=localhost:14051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER2_ORG-4-ORTHOPAEDICS_CA}
      export CORE_PEER_ADDRESS=localhost:14053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER3_ORG-4-ORTHOPAEDICS_CA}
      export CORE_PEER_ADDRESS=localhost:14055
    else
      errorln "PEER$2 Unknown"
    fi
  else
    errorln "ORG$USING_ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1 $2

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG == "ORG-1-CARDIOLOGY" ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_ADDRESS=peer0.ORG-1-CARDIOLOGY.example.com:7051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_ADDRESS=peer1.ORG-1-CARDIOLOGY.example.com:8051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_ADDRESS=peer2.ORG-1-CARDIOLOGY.example.com:8053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_ADDRESS=peer3.ORG-1-CARDIOLOGY.example.com:8055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG == "ORG-2-NEPHROLOGY" ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_ADDRESS=peer0.ORG-2-NEPHROLOGY.example.com:9051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_ADDRESS=peer1.ORG-2-NEPHROLOGY.example.com:12051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_ADDRESS=peer2.ORG-2-NEPHROLOGY.example.com:12053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_ADDRESS=peer3.ORG-2-NEPHROLOGY.example.com:12055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG == "ORG-3-EMERGENCY" ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_ADDRESS=peer0.ORG-3-EMERGENCY.example.com:10051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_ADDRESS=peer1.ORG-3-EMERGENCY.example.com:13051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_ADDRESS=peer2.ORG-3-EMERGENCY.example.com:13053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_ADDRESS=peer3.ORG-3-EMERGENCY.example.com:13055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG == "ORG-4-ORTHOPAEDICS" ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_ADDRESS=peer0.ORG-4-ORTHOPAEDICS.example.com:11051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_ADDRESS=peer1.ORG-4-ORTHOPAEDICS.example.com:14051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_ADDRESS=peer2.ORG-4-ORTHOPAEDICS.example.com:14053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_ADDRESS=peer3.ORG-4-ORTHOPAEDICS.example.com:14055
    else
      errorln "PEER$2 Unknown"
    fi
  else
    errorln "$USING_ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operationobal
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1 0
    PEER="peer0.$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    
    setGlobals $1 1
    PEER="peer1.$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER1_$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"

    

    #  if [$1 -eq 1 || $1 -eq 3];
    #  then
    #  {
            setGlobals $1 2
            PEER="peer2.$1"
            ## Set peer addresses
            PEERS="$PEERS $PEER"
            PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
            ## Set path to TLS certificate
            TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER2_$1_CA")
            PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
      # }
      # fi
    
    # if [!$1 -eq 4]; 
    # then
    # {
        setGlobals $1 3
        PEER="peer3.$1"
        ## Set peer addresses
        PEERS="$PEERS $PEER"
        PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
        ## Set path to TLS certificate
        TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER3_$1_CA")
        PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
        # shift by one to get to the next organization
    #}
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
