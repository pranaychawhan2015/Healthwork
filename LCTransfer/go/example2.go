package main

import (

	//"github.com/gopherjs/gopherjs/js"
	"crypto/aes"
	"crypto/cipher"
	"encoding/hex"
	"fmt"
	"math/big"
	//"reflect"
	//"strconv"
)

type Policy struct {
	Name   string   `json:"policyname"`
	Lambda *big.Int `json:lambda`
}

func main() {
	decodeKey, _ := hex.DecodeString("5548356797190766300362193419431397890624695387393337792911173317")
	block, err := aes.NewCipher([]byte(decodeKey))
	if err != nil {
		panic(err.Error())
	}
	fmt.Println(block)
	aesgcm, err := cipher.NewGCM(block)
	if err != nil {
		panic(err.Error())
	}

	bytes, _ := hex.DecodeString("ff87ff810301010b5472616e73616374696f6e01ff82000108010d50617469656e744e756d626572010c0001044e616d65010c000103416765010c000115446f63746f725f5370656369616c697a6174696f6e010c00010744697365617365010c000105456d61696c010c0001054164686172010c00010c4f7267616e697a6174696f6e010c00000059ff82010d70617469656e744e756d62657201044e616d6501034167650115446f63746f725f5370656369616c697a6174696f6e0107446973656173650105456d61696c01054164686172010c4f7267616e697a6174696f6e00")

	nonce, _ := hex.DecodeString("964f170ac4ba6469ac9da58b")
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
