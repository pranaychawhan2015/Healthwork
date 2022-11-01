package main

import (

	//"github.com/gopherjs/gopherjs/js"

	"crypto/aes"
	"crypto/cipher"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"math/big"
	"strings"
	//"reflect"
	//"strconv"
)

type Policy struct {
	Name   string   `json:"policyname"`
	Lambda *big.Int `json:lambda`
}

func main() {
	policy2 := `{"policy":{"Chief_engineer":-6194870606895355006036323113938112694776205396869153050933800713,"quality_check":11588981595520672947931690010524668363862030931473457543794380942}}`
	firstArray1 := strings.Split(policy2, `{"policy"`)
	res1 := `{"policy"` + firstArray1[1]
	var policyData map[string]map[string]*big.Int

	json.Unmarshal([]byte(res1), &policyData)
	fmt.Println("Res Data", policyData)

	//inputString := `{"policy":{"LaborRepresentative":-5223343366925548149404690088746676021809129697631265157336330283,"TrustedEntity":16279716166955665380076072373161426219924263586344497298925435573,"civilEngineer":-5919982010853369958667825730963378076127773202258062547101326491,"supplier":16279716166955665380076072373161426219924263586344497298925435573}}`
	inputString := `{"Name":"message","Value":"9fe2e7921e496059d6431c84676d68fb8d9ddaf1e2f570f2d605b9477b6c1f61baca8d1eb292055b218fadbda908dd3cfb76adca717636d12d93c089dedd918ef19935f00d4586e9c8727abf6130c38072d011fa85ac5fa7753539bf1123500b8942cbdecfa32d2f0d8b5385908bc902c7c423a5079ded1d0f9a7faf71234c906e0aa5e7b7754b5d4372d8eb88ef7b5afb31e04bcd95c73299057f9827a9b9624a91ebdedcce95c1f3","Nonce":"21f8cc4023ca7d96cfbebd40"}{"policy":{"LaborRepresentative":-5288556840166635323176292251066504679570500307698214608226171869,"TrustedEntity":16332136491356172672771415103841284508285229119625593405510590899,"civilEngineer":-5242801725232791917968909300272041021018093765821748050510488289,"supplier":16332136491356172672771415103841284508285229119625593405510590899}}`

	firstArray := strings.Split(inputString, `{"policy"`)
	res := `{"policy"` + firstArray[1]
	fmt.Println(res)
	var resData map[string]map[string]*big.Int
	json.Unmarshal([]byte(res), &resData)
	fmt.Println(resData["policy"]["LaborRepresentative"])

	secondArray := strings.Split(inputString, `"Name":"message","Value":`)
	thirdArray := strings.Split(secondArray[1], ",")
	fmt.Println(thirdArray[0])

	newString := strings.ReplaceAll(thirdArray[0], `"`, "")

	fmt.Println(newString)

	fourthArray := strings.Split(thirdArray[1], `"Nonce":`)
	fifthArray := strings.Split(fourthArray[1], `"}`)
	fmt.Println("Nonce", fifthArray[0])

	nonceString := strings.ReplaceAll(fifthArray[0], `"`, "")
	fmt.Println(nonceString)

	// nonce := make([]byte, 12)

	// fmt.Println("nonce 1", nonce)
	// if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
	// 	panic(err.Error())
	// }
	// fmt.Println("nonce 2", nonce)
	decodeKey, _ := hex.DecodeString("")
	block, err := aes.NewCipher([]byte(decodeKey))
	if err != nil {
		panic(err.Error())
	}
	fmt.Println(block)
	aesgcm, err := cipher.NewGCM(block)
	if err != nil {
		panic(err.Error())
	}

	fmt.Println(newString)
	bytes, _ := hex.DecodeString(newString)

	nonce, _ := hex.DecodeString(nonceString)
	fmt.Println(bytes)
	fmt.Println(nonce)
	plaintext2, err := aesgcm.Open(nil, nonce, bytes, nil)
	if err != nil {
		fmt.Println(err.Error())
		panic(err.Error())
	}
	fmt.Printf("Plain Text %s", plaintext2)

}

func base64(newString string) {
	panic("unimplemented")
}
