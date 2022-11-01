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

	"github.com/google/uuid"
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

func main() {
	msg1 := ""
	msg2 := ""

	msg1, msg2 = convertMessage()
	fmt.Println(msg1)
	fmt.Println(msg2)
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
		//fmt.Printf("key=%s, value=%s\n", k, v)

		// for nested objects call Visit again
		if string(k) == "peers" {
			v.GetObject().Visit(func(k []byte, v *fastjson.Value) {
				signValue := v.GetObject("signCert")
				//fmt.Println("SignValue", signValue.Get("pem").String())
				bytes1, _ := signValue.Get("pem").StringBytes()
				//fmt.Println("bytes", string(bytes1))
				pem2, _ := pem.Decode(bytes1)
				cert, err2 := x509.ParseCertificate(pem2.Bytes)
				if err2 != nil {
					panic(err2)
				}
				//fmt.Println("peer address", cert.DNSNames)

				count := 0
				peerName := string(k)
				var resData map[string]map[string]string

				for _, value := range cert.Extensions {
					json.Unmarshal(value.Value, &resData)
					if resData["attrs"] != nil {
						break
					}
				}

				var actualMap = resData["attrs"]
				//fmt.Println("attrs", actualMap)
				//fmt.Println("Endorsers", actualMap)
				for _, value := range actualMap {
					value1 := attributes[value]
					if value1 != nil {
						//fmt.Println("Count", count, "Value", value)
						count++
					}
				}
				url := v.Get("url").String()
				//fmt.Println("url", url)
				//fmt.Println("Count", count)
				//if count == len(attributes) {
				stringArray := strings.Split(url, "grpcs://localhost:")
				peerName = string(peerName) + ":" + stringArray[1]
				endorsersList = append(endorsersList, strings.ReplaceAll(peerName, `"`, ""))
				//fmt.Println("PeerNAme", strings.ReplaceAll(peerName, `"`, ""))
				//}
			})
		}
	})
	return endorsersList
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
		//fmt.Println("Row to Attr", valueFromMap)
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

	//fmt.Println("RowToAttr", RowToAttrib)
	count := 1
	for _, value := range RowToAttrib {
		index := 0
		if len(value) > 1 {
			rand1.Seed(time.Now().UnixNano())
			min := 0
			max := len(value) - 1
			index = rand1.Intn(max-min+1) + min
			//fmt.Println("index", index)
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
		//fmt.Println("received: ", string(msg.Value))

		var msg1 map[string]string
		json.Unmarshal([]byte(string(msg.Value)), &msg1)
		// if err != nil {
		// 	fmt.Println("Error", err)
		// } else {
		// 	fmt.Println("msg", msg1["Name"])
		// }
	}
}

func convertMessage() (output1 string, output2 string) {
	msg := `{"Name":"Pranay", "Email":"PranayChawhan2015@gmail.com", "Policy":"(National_Highway AND Suppliers_Raw_materials AND (Sand OR Soils OR Cement) )"}`
	//msg := `{"Name":"Pranay", "Email":"PranayChawhan2102@gmail.com"}`
	// after receiving the message, log its value
	//fmt.Println("received: ", msg)

	var msg1 map[string]string
	err := json.Unmarshal([]byte(string(msg)), &msg1)

	if err != nil {
		//fmt.Println("Error marshalling the json", err)
	} else {
		policy := msg1["Policy"]
		uuidWithHyphen := uuid.New()
		//fmt.Println(uuidWithHyphen)
		msg1["key"] = uuidWithHyphen.String()
		if policy == "" {
			//total := 0.0
			var network1 bytes.Buffer        // Stand-in for a network connection
			enc := gob.NewEncoder(&network1) // Will write to network.
			enc.Encode(msg1)
			//fmt.Println("Err", err)

			plaintext := hex.EncodeToString(network1.Bytes())

			//var MessageMap map[string]string
			MessageMap := make(map[string]string, 0)
			MessageMap["Value"] = plaintext
			//res2, _ := json.Marshal(MessageMap)
			return
		}
		delete(msg1, "Policy")
		msg := msg1

		var network1 bytes.Buffer        // Stand-in for a network connection
		enc := gob.NewEncoder(&network1) // Will write to network.

		err = enc.Encode(msg)
		if err != nil {
			log.Fatal("encode error:", err)
		}

		// HERE ARE YOUR BYTES!!!!
		//fmt.Println("Transaction Bytes", network1.Bytes())

		//a := abe.NewFAME()

		// stringArray := strings.Split(policy)
		// fmt.Println(stringArray)

		//pubKey, secKey, _ := a.GenerateMasterKeys()

		//fmt.Printf("secret Key: %v\n", secKey)
		//fmt.Printf("pubKey key: %v\n\n", pubKey)
		//fmt.Printf("policy:%v\n\n", policy)
		msp1, err := abe.BooleanToMSP(policy, false)
		fmt.Println(len(msp1.Mat[0]), err)

		vectorArray := make([]data.Vector, 0)

		for i := 0; i < len(msp1.Mat[0]); i++ {
			newBigInt, _ := rand.Prime(rand.Reader, 212)
			//newBigInt, _ := rand.Int(rand.Reader, )
			//fmt.Println(len(newBigInt.String()))
			for len(newBigInt.String()) != 64 {
				newBigInt, _ = rand.Prime(rand.Reader, 212)
				//fmt.Println(len(newBigInt.String()))
			}

			bigArray := make([]*big.Int, 1)
			bigArray[0] = newBigInt
			vector := data.NewVector(bigArray)

			vectorArray = append(vectorArray, vector)

			//fmt.Println("vector", vector)
		}

		//policyMap := RecursivePolicyFinder(msp1.Mat, msp1.RowToAttrib)
		policyMap := GetPolicy(msp1.Mat, msp1.RowToAttrib)
		//fmt.Println("PolicyMap", policyMap)
		matrix2, err := data.NewMatrix(vectorArray)
		if err != nil {
			//fmt.Println(err)
		}

		//fmt.Println(matrix2)
		answerVector, err := msp1.Mat.Mul(matrix2)
		if err != nil {
			//fmt.Println(err)
		}

		//fmt.Println("Answer", answerVector)

		for i := 0; i < len(msp1.RowToAttrib); i++ {
			answer := answerVector[i]
			value := policyMap[msp1.RowToAttrib[i]]
			if value != nil {
				policyMap[msp1.RowToAttrib[i]] = answer[0]
			}
		}
		//fmt.Println("PolicyMap2", policyMap)

		//fmt.Println("key", vectorArray[0].String())
		// fmt.Println(len(vectorArray[0].String()))
		array := strings.Split(vectorArray[0].String(), " ")
		// fmt.Println(array[0])
		// fmt.Println(array[1])
		key, err := hex.DecodeString(array[1])
		if err != nil {
			//fmt.Println(err)
		}
		plaintext := hex.EncodeToString(network1.Bytes())
		//fmt.Println("Plain Text after encoding", plaintext)
		//fmt.Println(len("9223372036854775807000000000000000000000000000000000000000000000"))
		block, err := aes.NewCipher(key)
		if err != nil {
			panic(err.Error())
		}

		// Never use more than 2^32 random nonces with a given key because of the risk of a repeat.
		nonce := make([]byte, 12)

		//fmt.Println("nonce 1", nonce)
		if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
			panic(err.Error())
		}
		//fmt.Println("nonce 2", nonce)
		//fmt.Println("nonce", hex.EncodeToString(nonce))
		aesgcm, err := cipher.NewGCM(block)
		if err != nil {
			panic(err.Error())
		}

		ciphertext := aesgcm.Seal(nil, nonce, []byte(plaintext), nil)

		//fmt.Printf("Cipher Text %x\n", ciphertext)

		if err != nil {
			//fmt.Printf("Error in policy\n", err)
		}
		//fmt.Printf("LSSS Matrix: %v \n", msp1)

		policyList := make(map[string]map[string]*big.Int)
		//fmt.Println(policyMap)
		policyList["policy"] = policyMap

		res, err := json.Marshal(policyList)
		if err != nil {
			//fmt.Println(err)
		}

		//fmt.Println("res", string(res))

		var resData map[string]map[string]*big.Int
		json.Unmarshal(res, &resData)

		res1 := hex.EncodeToString(ciphertext)
		//fmt.Println(res1)
		//fmt.Println(ciphertext)

		//var MessageMap map[string]string
		MessageMap := make(map[string]string, 0)
		MessageMap["Value"] = res1
		MessageMap["Nonce"] = hex.EncodeToString(nonce)

		//res2, _ := json.Marshal(MessageMap)
		//fmt.Println("res2", string(res2))

		_, err = aesgcm.Open(nil, nonce, ciphertext, nil)
		if err != nil {
			panic(err.Error())
		}
		//fmt.Println("plain Text", string(plaintext2))

		res2, _ := json.Marshal(MessageMap)

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

		//fmt.Println("attributes", policyMap)
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

		//fmt.Println("res2", string(res2))

		//fmt.Println("Endorsers", endorsers)
		// if len(endorsers) == 0 {
		// 	fmt.Println("No Endorsers from the required Policy")
		// } else {

		return string(res2), string(res)
	}

	return "", ""
}
