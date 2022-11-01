// package main

// //import "c"
// import (
// 	"bytes"
// 	"encoding/gob"
// 	"errors"
// 	"io/ioutil"
// 	"log"
// 	"os"
// 	"path/filepath"
// 	"reflect"
// 	"time"

// 	"github.com/fentec-project/gofe/abe"
// 	"github.com/fentec-project/gofe/data"
// 	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
// 	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"

// 	//"github.com/gopherjs/gopherjs/js"
// 	"fmt"
// 	"math/big"
// 	rand1 "math/rand"

// 	//"reflect"
// 	"crypto/aes"
// 	"crypto/cipher"
// 	"encoding/hex"
// 	"encoding/json"
// 	"io"

// 	//"strconv"
// 	"crypto/rand"
// 	//"math/rand"
// 	"strings"
// )

// type Policy struct {
// 	Name   string   `json:"policyname"`
// 	Lambda *big.Int `json:lambda`
// }

// type Message struct {
// 	Name  string `json:"Name"`
// 	Value string `json:Value`
// 	Nonce string `json:Nonce`
// }

// type Transaction struct {
// 	PatientNumber         string `json:PatientNumber`
// 	Name                  string `json:Name`
// 	Age                   string `json:Age`
// 	Doctor_Specialization string `json:Doctor_Specialization`
// 	Disease               string `json:Disease`
// 	Email                 string `json:Email`
// 	Adhar                 string `json:Adhar`
// 	Organization          string `json:Organization`
// }
// type Employee struct {
// 	Name   string `json:"empname"`
// 	Number int    `json:"empid"`
// }

// type PolicyList struct {
// 	Name   string
// 	Policy []Policy
// }

// //  func New(name string) *js.Object {
// //    return js.MakeWrapper(&Pet{name})
// //  }

// //  func (p *Pet) Name() string {
// //    return p.name
// //  }

// //  func (p *Pet) SetName(name string) {
// //    p.name = name
// //  }

// func populateWallet(wallet *gateway.Wallet) error {
// 	credPath := filepath.Join(
// 		"..",
// 		"..",
// 		"test-network",
// 		"organizations",
// 		"peerOrganizations",
// 		"org1.example.com",
// 		"users",
// 		"User1@org1.example.com",
// 		"msp",
// 	)

// 	certPath := filepath.Join(credPath, "signcerts", "cert.pem")
// 	// read the certificate pem
// 	cert, err := ioutil.ReadFile(filepath.Clean(certPath))
// 	if err != nil {
// 		return err
// 	}

// 	keyDir := filepath.Join(credPath, "keystore")
// 	// there's a single file in this dir containing the private key
// 	files, err := ioutil.ReadDir(keyDir)
// 	if err != nil {
// 		return err
// 	}
// 	if len(files) != 1 {
// 		return errors.New("keystore folder should have contain one file")
// 	}
// 	keyPath := filepath.Join(keyDir, files[0].Name())
// 	key, err := ioutil.ReadFile(filepath.Clean(keyPath))
// 	if err != nil {
// 		return err
// 	}

// 	identity := gateway.NewX509Identity("Org1MSP", string(cert), string(key))

// 	err = wallet.Put("appUser", identity)
// 	if err != nil {
// 		return err
// 	}
// 	return nil
// }
// func main() {

// 	os.Setenv("DISCOVERY_AS_LOCALHOST", "true")
// 	wallet, err := gateway.NewFileSystemWallet("wallet")
// 	if err != nil {
// 		fmt.Printf("Failed to create wallet: %s\n", err)
// 		os.Exit(1)
// 	}

// 	if !wallet.Exists("appUser") {
// 		err = populateWallet(wallet)
// 		if err != nil {
// 			fmt.Printf("Failed to populate wallet contents: %s\n", err)
// 			os.Exit(1)
// 		}
// 	}

// 	ccpPath := filepath.Join(
// 		"..",
// 		"..",
// 		"test-network",
// 		"organizations",
// 		"peerOrganizations",
// 		"org1.example.com",
// 		"connection-org1.yaml",
// 	)

// 	gw, err := gateway.Connect(
// 		gateway.WithConfig(config.FromFile(filepath.Clean(ccpPath))),
// 		gateway.WithIdentity(wallet, "appUser"),
// 	)
// 	if err != nil {
// 		fmt.Printf("Failed to connect to gateway: %s\n", err)
// 		os.Exit(1)
// 	}
// 	defer gw.Close()

// 	network, err := gw.GetNetwork("mychannel")
// 	if err != nil {
// 		fmt.Printf("Failed to get network: %s\n", err)
// 		os.Exit(1)
// 	}

// 	//msg := "Transaction ID : 6576755fae3453, Txn Request: submit Tender (Aadhar no:'231231233432'., phone no:7823086577, company name:'IDRBT', year of service: 2022)"
// 	user_attributes := []string{"civilEngineer", "LaborRepresentative", "supplier", "TrustedEntity", "ElectricalEngineer"}
// 	msg := &Transaction{PatientNumber: "patientNumber", Name: "Name", Age: "Age", Doctor_Specialization: "Doctor_Specialization", Disease: "Disease", Email: "Email", Adhar: "Adhar", Organization: "Organization"}
// 	var network1 bytes.Buffer        // Stand-in for a network connection
// 	enc := gob.NewEncoder(&network1) // Will write to network.
// 	// dec := gob.NewDecoder(&network1)

// 	err = enc.Encode(msg)
// 	if err != nil {
// 		log.Fatal("encode error:", err)
// 	}

// 	// HERE ARE YOUR BYTES!!!!
// 	fmt.Println("Transaction Bytes", network1.Bytes())

// 	//policy:="(civilEngineer AND ((LaborRepresentative OR supplier) OR ({LaborRepresentative} OR TrustedEntity) )) "
// 	//policy := "civilEngineer OR (LaborRepresentative AND (supplier OR TrustedEntity))"
// 	//policy := "Chief_engineer AND (Engineer_in_chief AND (Doctor OR Lab_Technician))"
// 	policy := "Chief_engineer AND quality_check"
// 	//policy := "civilEngineer OR LaborRepresentative AND Supplier"
// 	//min. 2 AND

// 	//stringArray := strings.Split(policy, "(")

// 	//policyArray := make(map[int][]string)
// 	// count1 := 0
// 	// for i := 0; i < len(stringArray); i++ {
// 	// 	if i == 1 {
// 	// 		if stringArray[i] == "AND" || stringArray[i] == "OR" {
// 	// 			firstString := stringArray[i-1]
// 	// 			if strings.Contains(stringArray[i-1], "(") {
// 	// 				firstString = strings.Replace(firstString, "(", "", 0)
// 	// 			}
// 	// 			policyArray[count1] = append(policyArray[count1], stringArray[i-1])
// 	// 			if stringArray[i] == "OR" {
// 	// 				count1 += 1
// 	// 			}
// 	// 		}
// 	// 	} else {
// 	// 		if stringArray[i] == "AND" {
// 	// 			firstString := stringArray[i-1]
// 	// 			if strings.Contains(firstString, "(") {
// 	// 				firstString = strings.Replace(firstString, "(", "", 0)
// 	// 			}
// 	// 			policyArray[count1] = append(policyArray[count1], firstString)

// 	// 			secondString := stringArray[i+1]
// 	// 			if strings.Contains(secondString, "(") {
// 	// 				secondString = strings.Replace(secondString, "(", "", 0)
// 	// 			}
// 	// 			policyArray[count1] = append(policyArray[count1], secondString)

// 	// 		} else if stringArray[i] == "OR" {
// 	// 			count1 += 1
// 	// 			fmt.Println(count1)
// 	// 			firstString := stringArray[i+1]
// 	// 			if strings.Contains(firstString, "(") {
// 	// 				firstString = strings.Replace(firstString, "(", "", 0)
// 	// 			}
// 	// 			// policyArray[count1] = append(policyArray[count1], firstString)

// 	// 			// for i := 0; i < len(policyArray[count1-1]); i++ {
// 	// 			// 	if policyArray[count1-1][i] != stringArray[i-1] {
// 	// 			// 		policyArray[count1] = append(policyArray[count1], policyArray[count1-1][i])
// 	// 			// 	}
// 	// 			// }
// 	// 		}
// 	// 	}
// 	// }
// 	// fmt.Println(policyArray)

// 	a := abe.NewFAME()

// 	// stringArray := strings.Split(policy)
// 	// fmt.Println(stringArray)
// 	pubKey, secKey, _ := a.GenerateMasterKeys()

// 	fmt.Printf("secret Key: %v\n", secKey)
// 	fmt.Printf("pubKey key: %v\n\n", pubKey)
// 	fmt.Printf("User Attributes: %v\n\n", user_attributes)
// 	fmt.Printf("policy:%v\n\n", policy)
// 	msp, err := abe.BooleanToMSP(policy, false)
// 	fmt.Println(len(msp.Mat[0]))
// 	//fmt.Println(data)
// 	//newBigInt := big.NewInt(12)
// 	//length := int(len(msp.Mat[0]))
// 	//var vectorArray []data.Vector = [length]data.Vector{}
// 	vectorArray := make([]data.Vector, 0)
// 	// numbers = append(numbers, 1)
// 	// numbers = append(numbers, 2)
// 	//AccessStructures = [[]]
// 	// firstDigit := big.NewInt(1)

// 	// secondDigit := big.NewInt(0)
// 	// for i := 0; i < len(msp.Mat); i++ {
// 	// 	count := 0
// 	// 	myMap := make(map[int][]string)
// 	// 	storedVectors := make([]data.Vector, 0)
// 	// 	for j := 0; j < len(msp.Mat[0]); j++ {
// 	// 		for k := i + 1; k < len(msp.Mat); k++ {
// 	// 			fmt.Println(big.NewInt(1))
// 	// 			//output := strconv.FormatInt(msp.Mat[i][j].Int64(), 2)
// 	// 			//msp.Mat[i][j] = strconv.FormatInt(msp.Mat[i][j].Int64(), 2)
// 	// 			//fmt.Println(output)
// 	// 			// if (msp.Mat[i][0].Cmp(firstDigit) == 0) {
// 	// 			//    fmt.Println("trie")
// 	// 			// }
// 	// 			fmt.Println(msp.Mat[i], msp.Mat[i], msp.RowToAttrib[i])

// 	// 			if len(msp.Mat[0]) >= 3 {
// 	// 				if msp.Mat[i][0].Cmp(firstDigit) == 0 && msp.Mat[i][1].Cmp(secondDigit) == 0 && msp.Mat[i][2].Cmp(secondDigit) == 0 {
// 	// 					fmt.Println(msp.Mat[i], msp.Mat[i], msp.RowToAttrib[i])
// 	// 				}
// 	// 			} else {
// 	// 				if msp.Mat[i][0].Cmp(firstDigit) == 0 && msp.Mat[i][1].Cmp(secondDigit) == 0 {
// 	// 					fmt.Println(msp.Mat[i], msp.Mat[i], msp.RowToAttrib[i])
// 	// 				}
// 	// 			}

// 	// 			newVector := msp.Mat[i].Add(msp.Mat[k])
// 	// 			//output1 := strconv.FormatInt(newVector[0].Int64(), 2)
// 	// 			//output2 := strconv.FormatInt(newVector[1].Int64(), 2)
// 	// 			//output3 := strconv.FormatInt(newVector[2].Int64(), 2)
// 	// 			//fmt.Println("first", newVector[0], newVector[1], newVector[2], msp.RowToAttrib[i], msp.RowToAttrib[k])

// 	// 			if len(newVector) >= 3 {
// 	// 				if newVector[0].Cmp(firstDigit) == 0 && newVector[1].Cmp(secondDigit) == 0 && newVector[2].Cmp(secondDigit) == 0 {
// 	// 					//fmt.Println("first", newVector[0], newVector[1], msp.RowToAttrib[i], msp.RowToAttrib[k])
// 	// 				}
// 	// 			} else {
// 	// 				if newVector[0].Cmp(firstDigit) == 0 && newVector[1].Cmp(secondDigit) == 0 {
// 	// 					//fmt.Println("second", newVector[0], newVector[1], msp.RowToAttrib[i], msp.RowToAttrib[k])
// 	// 				}
// 	// 			}
// 	// 			if len(myMap) >= 1 {
// 	// 				for index, strings := range myMap {
// 	// 					if len(storedVectors[index]) >= 3 {
// 	// 						storedVectors[index] = storedVectors[index].Add(newVector)
// 	// 						myMap[index] = append(myMap[index], msp.RowToAttrib[i], msp.RowToAttrib[k])
// 	// 						//fmt.Println("My Index", myMap[])
// 	// 						if storedVectors[index][0].Cmp(firstDigit) == 0 && storedVectors[index][1].Cmp(secondDigit) == 0 && storedVectors[index][2].Cmp(secondDigit) == 0 {
// 	// 							fmt.Println("first", storedVectors[index][0], storedVectors[index][1], myMap[index])
// 	// 						}
// 	// 					} else {
// 	// 						storedVectors[index] = storedVectors[index].Add(newVector)
// 	// 						myMap[index] = append(myMap[index], msp.RowToAttrib[i], msp.RowToAttrib[k])
// 	// 						fmt.Println("My Index", myMap[index])

// 	// 						if storedVectors[index][0].Cmp(firstDigit) == 0 && storedVectors[index][1].Cmp(secondDigit) == 0 {
// 	// 							fmt.Println("second", storedVectors[index][0], storedVectors[index][1], myMap[index])
// 	// 						}
// 	// 					}
// 	// 					fmt.Println(storedVectors[index], strings)
// 	// 				}
// 	// 			} else {
// 	// 				myMap[count] = []string{msp.RowToAttrib[i]}
// 	// 				storedVectors = append(storedVectors, msp.Mat[i])
// 	// 			}

// 	// 			count += 1
// 	// 			// fmt.Println(newVector,  msp.RowToAttrib[i], msp.RowToAttrib[k])
// 	// 		}
// 	// 	}
// 	// }

// 	for i := 0; i < len(msp.Mat[0]); i++ {
// 		newBigInt, _ := rand.Prime(rand.Reader, 212)
// 		//newBigInt, _ := rand.Int(rand.Reader, )
// 		fmt.Println(len(newBigInt.String()))
// 		for len(newBigInt.String()) != 64 {
// 			newBigInt, _ = rand.Prime(rand.Reader, 212)
// 			fmt.Println(len(newBigInt.String()))
// 		}

// 		bigArray := make([]*big.Int, 1)
// 		bigArray[0] = newBigInt
// 		vector := data.NewVector(bigArray)

// 		vectorArray = append(vectorArray, vector)

// 		fmt.Println("vector", vector)
// 	}

// 	policyMap := RecursivePolicyFinder(msp.Mat, msp.RowToAttrib)

// 	//fmt.Println(newBigInt)
// 	//newBigInt := big.NewInt(893489384394839834983498349348934989348934898934346374637647)
// 	//var bignum = new(big.Int)
// 	//fmt.Println(newBigInt)

// 	//svar bignum2, _ = new(big.Int).SetString("218882428714186575618", 0)
// 	//var vector1 []*big.Int = []*big.Int{4}
// 	// bigArray2 := make([]*big.Int, 1)
// 	// bigArray2[0] = big.NewInt(int64(6))
// 	// vector2 := data.NewVector(bigArray2)

// 	// bigArray3 := make([]*big.Int, 1)
// 	// bigArray3[0] = big.NewInt(int64(2))
// 	// // var bignum3, _ = new(big.Int).SetString("218882428714186575619", 0)
// 	// vector3 := data.NewVector(bigArray3)
// 	// // fmt.Println(vector1)
// 	// var vectorArray []data.Vector = []data.Vector{vector1, vector2, vector3}

// 	matrix2, err := data.NewMatrix(vectorArray)
// 	if err != nil {
// 		fmt.Println(err)
// 	}

// 	fmt.Println(matrix2)
// 	answerVector, err := msp.Mat.Mul(matrix2)
// 	if err != nil {
// 		fmt.Println(err)
// 	}

// 	fmt.Println("Answer", answerVector)

// 	for i := 0; i < len(msp.RowToAttrib); i++ {
// 		answer := answerVector[i]
// 		policyMap[msp.RowToAttrib[i]] = answer[0]
// 	}
// 	//cipher, err := a.Encrypt(msg, msp, pubKey)
// 	//bytes :=	make(byte, "9223372036854775807")
// 	//fmt.Println(bytes)
// 	//bytes := []byte("f76db7dfbdb4dfaf39e3bef9f34e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
// 	//fmt.Println(len("6368616e676520746869732070617373776f726420746f206120736563726574"))
// 	//fmt.Printf("bytes %v", bytes)
// 	//fmt.Println(len("f76db7dfbdb4dfaf39e3bef9f34e000000000000000000000000000000000000"))
// 	//fmt.Println(len("9223372036854775807"))
// 	//fmt.Println(len("9223372036854775807000000000000000000000000000000000000"))
// 	//key, _ := hex.DecodeString("9223372036854775807000000000000000000000000000000000000000000000")

// 	fmt.Println("key", vectorArray[0].String())
// 	fmt.Println(len(vectorArray[0].String()))
// 	array := strings.Split(vectorArray[0].String(), " ")
// 	fmt.Println(array[0])
// 	fmt.Println(array[1])
// 	key, err := hex.DecodeString(array[1])
// 	if err != nil {
// 		fmt.Println(err)
// 	}
// 	plaintext := hex.EncodeToString(network1.Bytes())
// 	fmt.Println("Plain Text after encoding", plaintext)
// 	//fmt.Println(len("9223372036854775807000000000000000000000000000000000000000000000"))
// 	block, err := aes.NewCipher(key)
// 	if err != nil {
// 		panic(err.Error())
// 	}

// 	// Never use more than 2^32 random nonces with a given key because of the risk of a repeat.
// 	nonce := make([]byte, 12)

// 	fmt.Println("nonce 1", nonce)
// 	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
// 		panic(err.Error())
// 	}
// 	fmt.Println("nonce 2", nonce)
// 	fmt.Println("nonce", hex.EncodeToString(nonce))
// 	aesgcm, err := cipher.NewGCM(block)
// 	if err != nil {
// 		panic(err.Error())
// 	}

// 	ciphertext := aesgcm.Seal(nil, nonce, []byte(plaintext), nil)

// 	fmt.Printf("Cipher Text %x\n", ciphertext)
// 	plaintext2, err := aesgcm.Open(nil, nonce, ciphertext, nil)
// 	if err != nil {
// 		panic(err.Error())
// 	}

// 	if err != nil {
// 		fmt.Printf("Error in policy\n", err)
// 	}
// 	fmt.Printf("LSSS Matrix: %v \n", msp)
// 	//fmt.Printf("Message: %s\n\n",msg)
// 	//fmt.Printf("Ciphertext:%x\n",cipher)

// 	// generate keys for decryption for an entity with
// 	// attributes user_attributes
// 	//userkeys, _ := a.GenerateAttribKeys(user_attributes, secKey)
// 	//demsg, err := a.Decrypt(cipher, userkeys, pubKey)
// 	//fmt.Println("user keys", userkeys.K0)
// 	//fmt.Println("Secret Key", secKey.PartInt)
// 	//fmt.Println("Secret Key", secKey.PartG1)
// 	//fmt.Printf("\nDecrypted Message:%v\n",demsg)

// 	//   js.Module.Get("exports").Set("pet", map[string]interface{}{
// 	//    "New": New,
// 	//  })

// 	//policyList := make([]Policy, 0)
// 	policyList := make(map[string]map[string]*big.Int)
// 	fmt.Println(policyMap)
// 	for key, value := range policyMap {
// 		//fmt.Println(Policy{key, value})
// 		policy := &Policy{Name: key, Lambda: value}
// 		res1, _ := json.Marshal(policy)
// 		fmt.Println(string(res1))
// 		//policyList = append(policyList, *policy)
// 	}
// 	policyList["policy"] = policyMap
// 	//res, err := json.Marshal(&PolicyList{Name: "policyMap", Policy: policyList})

// 	res, err := json.Marshal(policyList)
// 	if err != nil {
// 		fmt.Println(err)
// 	}

// 	fmt.Println("res", string(res))

// 	var resData map[string]map[string]*big.Int
// 	json.Unmarshal(res, &resData)
// 	fmt.Println("ex", resData["policy"]["LaborRepresentative"])

// 	res1 := hex.EncodeToString(ciphertext)
// 	fmt.Println(res1)
// 	fmt.Println(ciphertext)
// 	res2, _ := json.Marshal(&Message{Name: "message", Value: string(res1), Nonce: hex.EncodeToString(nonce)})
// 	fmt.Println("res2", string(res2))

// 	var Message1 Message
// 	err = json.Unmarshal(res2, &Message1)
// 	if err != nil {
// 		fmt.Println(err)
// 	}
// 	fmt.Println("Plain Text after decoding", Message1)
// 	// Decode (receive) the value.
// 	var decoded1 Transaction
// 	bytes1, _ := hex.DecodeString(Message1.Value)
// 	fmt.Println(bytes1)
// 	dec1 := gob.NewDecoder(bytes.NewReader(bytes1))
// 	err = dec1.Decode(&decoded1)
// 	if err != nil {
// 		log.Fatal("decode error:", err)
// 	}

// 	contract := network.GetContract("LC_Transfer")
// 	//sdk, err := fabsdk.New(config.FromReader(io.Reader.Read("/home/cps16/Documents/LCRecords/test-network/configtx/configtx.yaml"), "yaml", nil))

// 	// channelClientCtx := sdk.ChannelContext("mychannel", fabsdk.WithUser("Admin"), fabsdk.WithOrg("Org1"))
// 	// channelClient, err := channel.New(channelClientCtx)
// 	// req := channel.Request{
// 	// 	ChaincodeID: "LCTransfer",
// 	// 	Fcn:         "createPatient",
// 	// 	Args:        [][]byte{[]byte("patientNumber"), []byte("Name"), []byte("Age"), []byte("Doctor_Specialization"), []byte("Disease"), []byte("Email"), []byte("Adhar"), []byte("Organization"), []byte(string(res2)), []byte(string(res)), nil},
// 	// }

// 	//resp, err := channelClient.Execute(req, channel.WithTargetEndpoints("peer0.org1.example.com"), channel.WithRetry(retry.DefaultChannelOpts))
// 	// channelClientCtx := fabsdk.FabricSDK
// 	// req := channel.Request{
// 	// 	ChaincodeID: "healthwork",
// 	// 	Fcn:         "createPatient",
// 	// 	Args:        queryArg,
// 	// }
// 	//fmt.Println(resp)
// 	// resp, err := network.client.Query(req, channel.WithTargetEndpoints("peer0.org0.example.com"), channel.WithRetry(retry.DefaultChannelOpts))
// 	// transaction, _ := contract.CreateTransaction("createPatient")
// 	//"patientNumber", "Name", "Age", "Doctor_Specialization", "Disease", "Email", "Adhar", "Organization"
// 	contract.SubmitTransaction("createPatient", string(res2), string(res))
// }

// func RecursivePolicyFinder(matrix data.Matrix, rowAttributes []string) map[string]*big.Int {

// 	attributes := make(map[int][]string, 0)

// 	count := 0
// 	duplicateAttributes := make([]string, 0)
// 	totalMap := make(map[string]*big.Int, 0)

// 	for i := 0; i < len(matrix); i++ {
// 		fmt.Println(matrix[i])
// 		totalMap[rowAttributes[i]] = big.NewInt(int64(i))

// 		for j := i + 1; j < len(matrix); j++ {
// 			if reflect.DeepEqual(matrix[i], matrix[j]) {
// 				attributes[count] = append(attributes[count], rowAttributes[i])
// 				attributes[count] = append(attributes[count], rowAttributes[j])
// 			}
// 		}
// 		count += 1
// 	}

// 	count = 0
// 	for _, value := range attributes {
// 		rand1.Seed(time.Now().UnixNano())
// 		newCondition := randNew()
// 		if newCondition {
// 			duplicateAttributes = append(duplicateAttributes, value[0])
// 			delete(totalMap, value[1])
// 		} else {
// 			duplicateAttributes = append(duplicateAttributes, value[1])
// 			delete(totalMap, value[0])
// 		}
// 	}

// 	fmt.Println(duplicateAttributes)
// 	return totalMap
// }

// func randNew() bool {
// 	return rand1.Float32() < 0.5
// }

// func remove(slice []string, s int) []string {
// 	return append(slice[:s], slice[s+1:]...)
// }
