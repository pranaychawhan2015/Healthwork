package main

//import "c"
import (
	"bytes"
	"context"

	//"context"
	"encoding/gob"
	"encoding/pem"
	"errors"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"reflect"
	"time"

	"github.com/valyala/fastjson"

	//"golang.org/x/exp/slices"

	// "github.com/cloudflare/cfssl/api"

	"github.com/fentec-project/gofe/abe"
	"github.com/fentec-project/gofe/data"
	"github.com/segmentio/kafka-go"

	//"github.com/hyperledger/fabric-protos-go/msp"

	// "github.com/hyperledger/fabric-protos-go/msp"
	// "github.com/hyperledger/fabric-sdk-go/pkg/common/providers/context"

	//"github.com/hyperledger/fabric-sdk-go/pkg/common/providers/context"

	"github.com/hyperledger/fabric-sdk-go/pkg/client/channel/invoke"
	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"

	// "github.com/hyperledger/fabric-sdk-go/rc1/pkg/common/providers/msp"

	//"github.com/gopherjs/gopherjs/js"
	"fmt"
	"math/big"
	rand1 "math/rand"

	//"reflect"
	"crypto/aes"
	"crypto/cipher"
	"crypto/x509"
	"encoding/hex"
	"encoding/json"
	"io"

	//"github.com/segmentio/kafka-go"

	//"strconv"
	"crypto/rand"
	//"math/rand"
	"strings"
)

const (
	topic         = "quickstart-events"
	brokerAddress = "172.16.85.128:9092"
)

type Policy struct {
	Name   string   `json:"policyname"`
	Lambda *big.Int `json:lambda`
}

type Message struct {
	Name  string `json:"Name"`
	Value string `json:Value`
	Nonce string `json:Nonce`
}

type Transaction struct {
	PatientNumber         string `json:PatientNumber`
	Name                  string `json:Name`
	Age                   string `json:Age`
	Doctor_Specialization string `json:Doctor_Specialization`
	Disease               string `json:Disease`
	Email                 string `json:Email`
	Adhar                 string `json:Adhar`
	Organization          string `json:Organization`
}

type Employee struct {
	Name   string `json:"empname"`
	Number int    `json:"empid"`
}

type PolicyList struct {
	Name   string
	Policy []Policy
}

// const (
// 	topic         = "quickstart-events"
// 	brokerAddress = "172.16.85.208:9092"
// )

type Org1 struct {
	Name    string `json:"name"`
	Version string `json:"version"`
	Client  struct {
		Organization string `json:"organization"`
		Connection   struct {
			Timeout struct {
				Peer struct {
					Endorser string `json:"endorser"`
				} `json:"peer"`
			} `json:"timeout"`
		} `json:"connection"`
	} `json:"client"`
	Organizations struct {
		Org1 struct {
			Mspid                  string   `json:"mspid"`
			Peers                  []string `json:"peers"`
			CertificateAuthorities []string `json:"certificateAuthorities"`
		} `json:"Org1"`
	} `json:"organizations"`
	Peers struct {
		Peer0Org1ExampleCom struct {
			URL        string `json:"url"`
			TLSCACerts struct {
				Pem string `json:"pem"`
			} `json:"tlsCACerts"`
			GrpcOptions struct {
				SslTargetNameOverride string `json:"ssl-target-name-override"`
				HostnameOverride      string `json:"hostnameOverride"`
			} `json:"grpcOptions"`
			SignCert struct {
				Pem string `json:"pem"`
			} `json:"signCert"`
			PrivateKey struct {
				Pem string `json:"pem"`
			} `json:"privateKey"`
		} `json:"peer0.org1.example.com"`
		Peer1Org1ExampleCom struct {
			URL        string `json:"url"`
			TLSCACerts struct {
				Pem string `json:"pem"`
			} `json:"tlsCACerts"`
			GrpcOptions struct {
				SslTargetNameOverride string `json:"ssl-target-name-override"`
				HostnameOverride      string `json:"hostnameOverride"`
			} `json:"grpcOptions"`
			SignCert struct {
				Pem string `json:"pem"`
			} `json:"signCert"`
			PrivateKey struct {
				Pem string `json:"pem"`
			} `json:"privateKey"`
		} `json:"peer1.org1.example.com"`
		Peer2Org1ExampleCom struct {
			URL        string `json:"url"`
			TLSCACerts struct {
				Pem string `json:"pem"`
			} `json:"tlsCACerts"`
			GrpcOptions struct {
				SslTargetNameOverride string `json:"ssl-target-name-override"`
				HostnameOverride      string `json:"hostnameOverride"`
			} `json:"grpcOptions"`
			SignCert struct {
				Pem string `json:"pem"`
			} `json:"signCert"`
			PrivateKey struct {
				Pem string `json:"pem"`
			} `json:"privateKey"`
		} `json:"peer2.org1.example.com"`
		Peer3Org1ExampleCom struct {
			URL        string `json:"url"`
			TLSCACerts struct {
				Pem string `json:"pem"`
			} `json:"tlsCACerts"`
			GrpcOptions struct {
				SslTargetNameOverride string `json:"ssl-target-name-override"`
				HostnameOverride      string `json:"hostnameOverride"`
			} `json:"grpcOptions"`
			SignCert struct {
				Pem string `json:"pem"`
			} `json:"signCert"`
			PrivateKey struct {
				Pem string `json:"pem"`
			} `json:"privateKey"`
		} `json:"peer3.org1.example.com"`
	} `json:"peers"`
	CertificateAuthorities struct {
		CaOrg1ExampleCom struct {
			URL        string `json:"url"`
			CaName     string `json:"caName"`
			TLSCACerts struct {
				Pem []string `json:"pem"`
			} `json:"tlsCACerts"`
			HTTPOptions struct {
				Verify bool `json:"verify"`
			} `json:"httpOptions"`
		} `json:"ca.org1.example.com"`
	} `json:"certificateAuthorities"`
}

type Org2 struct {
	Name    string `json:"name"`
	Version string `json:"version"`
	Client  struct {
		Organization string `json:"organization"`
		Connection   struct {
			Timeout struct {
				Peer struct {
					Endorser string `json:"endorser"`
				} `json:"peer"`
			} `json:"timeout"`
		} `json:"connection"`
	} `json:"client"`
	Organizations struct {
		Org2 struct {
			Mspid                  string   `json:"mspid"`
			Peers                  []string `json:"peers"`
			CertificateAuthorities []string `json:"certificateAuthorities"`
		} `json:"Org2"`
	} `json:"organizations"`
	Peers struct {
		Peer0Org2ExampleCom struct {
			URL        string `json:"url"`
			TLSCACerts struct {
				Pem string `json:"pem"`
			} `json:"tlsCACerts"`
			GrpcOptions struct {
				SslTargetNameOverride string `json:"ssl-target-name-override"`
				HostnameOverride      string `json:"hostnameOverride"`
			} `json:"grpcOptions"`
			SignCert struct {
				Pem string `json:"pem"`
			} `json:"signCert"`
			PrivateKey struct {
				Pem string `json:"pem"`
			} `json:"privateKey"`
		} `json:"peer0.org2.example.com"`
		Peer1Org2ExampleCom struct {
			URL        string `json:"url"`
			TLSCACerts struct {
				Pem string `json:"pem"`
			} `json:"tlsCACerts"`
			GrpcOptions struct {
				SslTargetNameOverride string `json:"ssl-target-name-override"`
				HostnameOverride      string `json:"hostnameOverride"`
			} `json:"grpcOptions"`
			SignCert struct {
				Pem string `json:"pem"`
			} `json:"signCert"`
			PrivateKey struct {
				Pem string `json:"pem"`
			} `json:"privateKey"`
		} `json:"peer1.org2.example.com"`
		Peer2Org2ExampleCom struct {
			URL        string `json:"url"`
			TLSCACerts struct {
				Pem string `json:"pem"`
			} `json:"tlsCACerts"`
			GrpcOptions struct {
				SslTargetNameOverride string `json:"ssl-target-name-override"`
				HostnameOverride      string `json:"hostnameOverride"`
			} `json:"grpcOptions"`
			SignCert struct {
				Pem string `json:"pem"`
			} `json:"signCert"`
			PrivateKey struct {
				Pem string `json:"pem"`
			} `json:"privateKey"`
		} `json:"peer2.org2.example.com"`
		Peer3Org2ExampleCom struct {
			URL        string `json:"url"`
			TLSCACerts struct {
				Pem string `json:"pem"`
			} `json:"tlsCACerts"`
			GrpcOptions struct {
				SslTargetNameOverride string `json:"ssl-target-name-override"`
				HostnameOverride      string `json:"hostnameOverride"`
			} `json:"grpcOptions"`
			SignCert struct {
				Pem string `json:"pem"`
			} `json:"signCert"`
			PrivateKey struct {
				Pem string `json:"pem"`
			} `json:"privateKey"`
		} `json:"peer3.org2.example.com"`
	} `json:"peers"`
	CertificateAuthorities struct {
		CaOrg2ExampleCom struct {
			URL        string `json:"url"`
			CaName     string `json:"caName"`
			TLSCACerts struct {
				Pem []string `json:"pem"`
			} `json:"tlsCACerts"`
			HTTPOptions struct {
				Verify bool `json:"verify"`
			} `json:"httpOptions"`
		} `json:"ca.org2.example.com"`
	} `json:"certificateAuthorities"`
}

func main() {
	os.Setenv("DISCOVERY_AS_LOCALHOST", "true")
	wallet, err := gateway.NewFileSystemWallet("wallet")
	if err != nil {
		fmt.Printf("Failed to create wallet: %s\n", err)
		os.Exit(1)
	}

	if !wallet.Exists("appUser") {
		err = populateWallet(wallet, "appUser")
		if err != nil {
			fmt.Printf("Failed to populate wallet contents: %s\n", err)
			os.Exit(1)
		}
	}

	if !wallet.Exists("admin") {
		err = populateWallet(wallet, "admin")
		if err != nil {
			fmt.Printf("Failed to populate wallet contents: %s\n", err)
			os.Exit(1)
		}

	}

	ccpPath := filepath.Join(
		"..",
		"..",
		"test-network",
		"organizations",
		"peerOrganizations",
		"org1.example.com",
		"connection-org1.yaml",
	)

	gw, err := gateway.Connect(
		gateway.WithConfig(config.FromFile(filepath.Clean(ccpPath))),
		gateway.WithIdentity(wallet, "appUser"),
	)
	if err != nil {
		fmt.Printf("Failed to connect to gateway: %s\n", err)
		os.Exit(1)
	}
	defer gw.Close()

	network, err := gw.GetNetwork("mychannel")
	if err != nil {
		fmt.Printf("Failed to get network: %s\n", err)
		os.Exit(1)
	}

	contract := network.GetContract("LC_Transfer9")
	//consume(ctx)

	// create a new logger that outputs to stdout
	// and has the `kafka reader` prefix
	// the `ReadMessage` method blocks until we receive the next event
	//msg, err := r.ReadMessage(ctx)
	// if err != nil {
	// 	panic("could not read message " + err.Error())
	// }

	msg := `{"Name":"Pranay", "Email":"PranayChawhan2015@gmail.com", "Policy":"(National_Highway AND Suppliers_Raw_materials AND (Sand OR Soils OR Cement) )"}`
	// after receiving the message, log its value
	fmt.Println("received: ", msg)

	var msg1 map[string]string
	err = json.Unmarshal([]byte(string(msg)), &msg1)

	if err != nil {
		fmt.Println("Error marshalling the json", err)
	} else {

		policy := msg1["Policy"]
		delete(msg1, "Policy")
		msg := msg1

		var network1 bytes.Buffer        // Stand-in for a network connection
		enc := gob.NewEncoder(&network1) // Will write to network.

		err = enc.Encode(msg)
		if err != nil {
			log.Fatal("encode error:", err)
		}

		// HERE ARE YOUR BYTES!!!!
		fmt.Println("Transaction Bytes", network1.Bytes())

		a := abe.NewFAME()

		// stringArray := strings.Split(policy)
		// fmt.Println(stringArray)
		pubKey, secKey, _ := a.GenerateMasterKeys()

		fmt.Printf("secret Key: %v\n", secKey)
		fmt.Printf("pubKey key: %v\n\n", pubKey)
		fmt.Printf("policy:%v\n\n", policy)
		msp1, err := abe.BooleanToMSP(policy, false)
		fmt.Println(len(msp1.Mat[0]))

		vectorArray := make([]data.Vector, 0)

		for i := 0; i < len(msp1.Mat[0]); i++ {
			newBigInt, _ := rand.Prime(rand.Reader, 212)
			//newBigInt, _ := rand.Int(rand.Reader, )
			fmt.Println(len(newBigInt.String()))
			for len(newBigInt.String()) != 64 {
				newBigInt, _ = rand.Prime(rand.Reader, 212)
				fmt.Println(len(newBigInt.String()))
			}

			bigArray := make([]*big.Int, 1)
			bigArray[0] = newBigInt
			vector := data.NewVector(bigArray)

			vectorArray = append(vectorArray, vector)

			fmt.Println("vector", vector)
		}

		//policyMap := RecursivePolicyFinder(msp1.Mat, msp1.RowToAttrib)
		policyMap := GetPolicy(msp1.Mat, msp1.RowToAttrib)
		fmt.Println("PolicyMap", policyMap)
		matrix2, err := data.NewMatrix(vectorArray)
		if err != nil {
			fmt.Println(err)
		}

		fmt.Println(matrix2)
		answerVector, err := msp1.Mat.Mul(matrix2)
		if err != nil {
			fmt.Println(err)
		}

		fmt.Println("Answer", answerVector)

		for i := 0; i < len(msp1.RowToAttrib); i++ {
			answer := answerVector[i]
			value := policyMap[msp1.RowToAttrib[i]]
			if value != nil {
				policyMap[msp1.RowToAttrib[i]] = answer[0]
			}
		}
		fmt.Println("PolicyMap2", policyMap)

		fmt.Println("key", vectorArray[0].String())
		// fmt.Println(len(vectorArray[0].String()))
		array := strings.Split(vectorArray[0].String(), " ")
		// fmt.Println(array[0])
		// fmt.Println(array[1])
		key, err := hex.DecodeString(array[1])
		if err != nil {
			fmt.Println(err)
		}
		plaintext := hex.EncodeToString(network1.Bytes())
		fmt.Println("Plain Text after encoding", plaintext)
		//fmt.Println(len("9223372036854775807000000000000000000000000000000000000000000000"))
		block, err := aes.NewCipher(key)
		if err != nil {
			panic(err.Error())
		}

		// Never use more than 2^32 random nonces with a given key because of the risk of a repeat.
		nonce := make([]byte, 12)

		fmt.Println("nonce 1", nonce)
		if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
			panic(err.Error())
		}
		fmt.Println("nonce 2", nonce)
		fmt.Println("nonce", hex.EncodeToString(nonce))
		aesgcm, err := cipher.NewGCM(block)
		if err != nil {
			panic(err.Error())
		}

		ciphertext := aesgcm.Seal(nil, nonce, []byte(plaintext), nil)

		fmt.Printf("Cipher Text %x\n", ciphertext)

		if err != nil {
			fmt.Printf("Error in policy\n", err)
		}
		fmt.Printf("LSSS Matrix: %v \n", msp1)

		policyList := make(map[string]map[string]*big.Int)
		fmt.Println(policyMap)
		policyList["policy"] = policyMap

		res, err := json.Marshal(policyList)
		if err != nil {
			fmt.Println(err)
		}

		fmt.Println("res", string(res))

		var resData map[string]map[string]*big.Int
		json.Unmarshal(res, &resData)

		res1 := hex.EncodeToString(ciphertext)
		fmt.Println(res1)
		fmt.Println(ciphertext)

		var MessageMap map[string]string
		MessageMap = make(map[string]string, 0)
		MessageMap["Value"] = res1
		MessageMap["Nonce"] = hex.EncodeToString(nonce)

		res2, _ := json.Marshal(MessageMap)
		fmt.Println("res2", string(res2))

		plaintext2, err := aesgcm.Open(nil, nonce, ciphertext, nil)
		if err != nil {
			panic(err.Error())
		}
		fmt.Println("plain Text", string(plaintext2))

		// Decode (receive) the value.

		// var decoded1 map[string]string
		// bytes1, _ := hex.DecodeString(string(plaintext2))
		// fmt.Println("bytes", bytes1)
		// dec1 := gob.NewDecoder(bytes.NewBuffer(bytes1))
		// err = dec1.Decode(&decoded1)
		// if err != nil {
		// 	log.Fatal("decode error:", err.Error())
		// }

		// bytes2, _ := hex.DecodeString(plaintext)
		// nonce1, _ := hex.DecodeString(hex.EncodeToString(nonce))
		// fmt.Println(bytes2)
		// fmt.Println(nonce1)

		res2, _ = json.Marshal(MessageMap)

		endorsers := make([]string, 0)

		jsonPath := filepath.Join(
			"..",
			"..",
			"test-network",
			"organizations",
			"peerOrganizations",
			"org1.example.com",
			"connection-org1.json",
		)

		fmt.Println("attributes", policyMap)
		//fmt.Println("Endorsers", endorsers)
		endorsers = GetEndorsers(jsonPath, policyMap, endorsers)
		jsonPath2 := filepath.Join(
			"..",
			"..",
			"test-network",
			"organizations",
			"peerOrganizations",
			"org2.example.com",
			"connection-org2.json",
		)

		endorsers = GetEndorsers(jsonPath2, policyMap, endorsers)

		fmt.Println("res2", string(res2))

		fmt.Println(endorsers)
		if len(endorsers) == 0 {
			fmt.Println("No Endorsers from the required Policy")
		} else {
			txn, _ := contract.CreateTransaction("CreateRecord", gateway.WithEndorsingPeers(endorsers...))
			fmt.Println("key", vectorArray[0].String())

			byteArray1 := make([][]byte, 0)
			byteArray1 = append(byteArray1, []byte(string(res2)))
			byteArray1 = append(byteArray1, []byte(string(res)))
			endorsementHandler := invoke.NewEndorsementHandler()
			endorsementHandler.Handle(&invoke.RequestContext{Request: invoke.Request{ChaincodeID: "LC_Transfer9", Fcn: "CreateRecord", Args: byteArray1}}, nil)

			start := time.Now()
			_, err = txn.Submit(string(res2), string(res))
			end := time.Now()
			elapsed := end.Sub(start)
			if err != nil {
				fmt.Println(err)
			} else {
				fmt.Printf("Transaction time is %f seconds", elapsed.Seconds())
			}
		}

	}

}

func populateWallet(wallet *gateway.Wallet, name string) error {

	credPath := filepath.Join(
		"..",
		"..",
		"test-network",
		"organizations",
		"peerOrganizations",
		"org1.example.com",
		"users",
		"User1@org1.example.com",
		"msp",
	)
	if name == "admin" {
		credPath = filepath.Join(
			"..",
			"..",
			"test-network",
			"organizations",
			"peerOrganizations",
			"org1.example.com",
			"users",
			"Admin@org1.example.com",
			"msp",
		)
	}

	certPath := filepath.Join(credPath, "signcerts", "cert.pem")
	// read the certificate pem
	cert, err := ioutil.ReadFile(filepath.Clean(certPath))
	if err != nil {
		return err
	}

	keyDir := filepath.Join(credPath, "keystore")
	// there's a single file in this dir containing the private key
	files, err := ioutil.ReadDir(keyDir)
	if err != nil {
		return err
	}
	if len(files) != 1 {
		return errors.New("keystore folder should have contain one file")
	}
	keyPath := filepath.Join(keyDir, files[0].Name())
	key, err := ioutil.ReadFile(filepath.Clean(keyPath))
	if err != nil {
		return err
	}

	identity := gateway.NewX509Identity("Org1MSP", string(cert), string(key))

	err = wallet.Put(name, identity)
	if err != nil {
		return err
	}
	return nil
}

func GetEndorsers(Path string, attributes map[string]*big.Int, endorsersList []string) []string {
	bytes1, _ := ioutil.ReadFile(Path)

	var p fastjson.Parser
	v, err := p.Parse(string(bytes1))
	if err != nil {
		log.Fatal("Error", err)
	}

	v.GetObject().Visit(func(k []byte, v *fastjson.Value) {
		fmt.Printf("key=%s, value=%s\n", k, v)

		// for nested objects call Visit again
		if string(k) == "peers" {
			v.GetObject().Visit(func(k []byte, v *fastjson.Value) {
				signValue := v.GetObject("signCert")
				fmt.Println("SignValue", signValue.Get("pem").String())
				bytes1, _ := signValue.Get("pem").StringBytes()
				fmt.Println("bytes", string(bytes1))
				pem2, _ := pem.Decode(bytes1)
				cert, err2 := x509.ParseCertificate(pem2.Bytes)
				if err2 != nil {
					panic(err2)
				}

				count := 0
				peerName := string(k)
				var resData map[string]map[string]string
				json.Unmarshal(cert.Extensions[5].Value, &resData)

				var actualMap = resData["attrs"]

				//fmt.Println("Endorsers", actualMap)
				for _, value := range actualMap {
					value1 := attributes[value]
					if value1 != nil {
						fmt.Println("Count", count, "Value", value)
						count++
					}
				}
				url := v.Get("url").String()
				fmt.Println("url", url)
				fmt.Println("Count", count)
				if count == len(attributes) {
					stringArray := strings.Split(url, "grpcs://localhost:")
					peerName := string(peerName) + ":" + stringArray[1]
					endorsersList = append(endorsersList, strings.ReplaceAll(peerName, `"`, ""))
					fmt.Println("PeerNAme", strings.ReplaceAll(peerName, `"`, ""))
				}

			})
		}
	})
	return endorsersList
}

func RecursivePolicyFinder(matrix data.Matrix, rowAttributes []string) map[string]*big.Int {

	attributes := make(map[int][]string, 0)

	count := 0
	duplicateAttributes := make([]string, 0)
	totalMap := make(map[string]*big.Int, 0)

	for i := 0; i < len(matrix); i++ {
		fmt.Println(matrix[i])
		totalMap[rowAttributes[i]] = big.NewInt(int64(i))

		for j := i + 1; j < len(matrix); j++ {
			if reflect.DeepEqual(matrix[i], matrix[j]) {
				attributes[count] = append(attributes[count], rowAttributes[i])
				attributes[count] = append(attributes[count], rowAttributes[j])
			}
		}
		count += 1
	}

	count = 0
	fmt.Println("attributes", attributes)
	for _, value := range attributes {
		rand1.Seed(time.Now().UnixNano())
		newCondition := randNew()
		if newCondition {
			duplicateAttributes = append(duplicateAttributes, value[0])
			delete(totalMap, value[1])
		} else {
			duplicateAttributes = append(duplicateAttributes, value[1])
			delete(totalMap, value[0])
		}
	}

	fmt.Println("Duplicate Attributes", duplicateAttributes)

	return totalMap
}

func GetPolicy(matrix data.Matrix, rowAttributes []string) map[string]*big.Int {

	RowToAttrib := make(map[string][]string, 0)

	for i := 0; i < len(matrix); i++ {
		//newString := matrix[i][0].String() + matrix[i][1].String() + matrix[i][2].String()
		newString := ""
		for j := 0; j < len(matrix[i]); j++ {
			newString += matrix[i][j].String()
		}
		valueFromMap := RowToAttrib[newString]
		valueFromMap = append(valueFromMap, rowAttributes[i])
		fmt.Println("Row to Attr", valueFromMap)
		for j := i + 1; j < len(matrix); j++ {
			newString1 := ""

			for k := 0; k < len(matrix[j]); k++ {
				newString1 += matrix[j][k].String()
			}
			if newString1 == newString {
				valueFromMap = append(valueFromMap, rowAttributes[j])
			}
		}
		RowToAttrib[newString] = valueFromMap
	}
	totalMap := make(map[string]*big.Int, 0)

	fmt.Println("RowToAttr", RowToAttrib)
	count := 1
	for _, value := range RowToAttrib {
		index := 0
		if len(value) > 1 {
			rand1.Seed(time.Now().UnixNano())
			min := 0
			max := len(value) - 1
			index = rand1.Intn(max-min+1) + min
			fmt.Println("index", index)
		} else {
			index = 0
		}
		totalMap[value[index]] = big.NewInt(int64(count))
		count++
	}

	return totalMap
}

func randNew() bool {
	return rand1.Float32() < 0.5
}

func remove(slice []string, s int) []string {
	return append(slice[:s], slice[s+1:]...)
}

func getAttr(obj interface{}, fieldName string) reflect.Value {
	pointToStruct := reflect.ValueOf(obj) // addressable
	curStruct := pointToStruct.Elem()
	if curStruct.Kind() != reflect.Struct {
		panic("not struct")
	}
	curField := curStruct.FieldByName(fieldName) // type: reflect.Value
	if !curField.IsValid() {
		panic("not found:" + fieldName)
	}
	return curField
}

func consume(ctx context.Context) {
	// create a new logger that outputs to stdout
	// and has the `kafka reader` prefix
	l := log.New(os.Stdout, "kafka reader: ", 2)
	// initialize a new reader with the brokers and topic
	// the groupID identifies the consumer and prevents
	// it from receiving duplicate messages
	r := kafka.NewReader(kafka.ReaderConfig{
		Brokers: []string{brokerAddress},
		Topic:   topic,
		//GroupID: "my-group",
		// assign the logger to the reader
		Logger: l,
	})
	for {
		// the `ReadMessage` method blocks until we receive the next event
		msg, err := r.ReadMessage(ctx)
		if err != nil {
			panic("could not read message " + err.Error())
		}
		// after receiving the message, log its value
		fmt.Println("received: ", string(msg.Value))

		var msg1 map[string]string
		err = json.Unmarshal([]byte(string(msg.Value)), &msg1)
		if err != nil {
			fmt.Println("Error", err)
		} else {
			fmt.Println("msg", msg1["Name"])
		}
	}
}
