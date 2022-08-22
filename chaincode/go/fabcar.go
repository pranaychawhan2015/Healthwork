/*
SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"bytes"
	"encoding/gob"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"log"
	"strconv"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for managing a car
type SmartContract struct {
	contractapi.Contract
}
type Message struct {
	Name  string `json:"Name"`
	Value string `json:"Value"`
	Nonce string `json:"Nonce"`
}

type Transaction struct {
	PatientNumber         string `json:"PatientNumber"`
	Name                  string `json:"Name"`
	Age                   string `json:"Age"`
	Doctor_Specialization string `json:"Doctor_Specialization"`
	Disease               string `json:"Disease"`
	Email                 string `json:"Email"`
	Adhar                 string `json:"Adhar"`
	Organization          string `json:"Organization"`
}

// Car describes basic details of what makes up a car
type Car struct {
	Make   string `json:"make"`
	Model  string `json:"model"`
	Colour string `json:"colour"`
	Owner  string `json:"owner"`
}

// QueryResult structure used for handling result of query
type QueryResult struct {
	Key    string `json:"Key"`
	Record *Car
}

// InitLedger adds a base set of cars to the ledger
func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	cars := []Car{
		Car{Make: "Toyota", Model: "Prius", Colour: "blue", Owner: "Tomoko"},
		Car{Make: "Ford", Model: "Mustang", Colour: "red", Owner: "Brad"},
		Car{Make: "Hyundai", Model: "Tucson", Colour: "green", Owner: "Jin Soo"},
		Car{Make: "Volkswagen", Model: "Passat", Colour: "yellow", Owner: "Max"},
		Car{Make: "Tesla", Model: "S", Colour: "black", Owner: "Adriana"},
		Car{Make: "Peugeot", Model: "205", Colour: "purple", Owner: "Michel"},
		Car{Make: "Chery", Model: "S22L", Colour: "white", Owner: "Aarav"},
		Car{Make: "Fiat", Model: "Punto", Colour: "violet", Owner: "Pari"},
		Car{Make: "Tata", Model: "Nano", Colour: "indigo", Owner: "Valeria"},
		Car{Make: "Holden", Model: "Barina", Colour: "brown", Owner: "Shotaro"},
	}

	for i, car := range cars {
		carAsBytes, _ := json.Marshal(car)
		err := ctx.GetStub().PutState("CAR"+strconv.Itoa(i), carAsBytes)

		if err != nil {
			return fmt.Errorf("Failed to put to world state. %s", err.Error())
		}
	}

	return nil
}

// CreateCar adds a new car to the world state with given details
func (s *SmartContract) CreateCar(ctx contractapi.TransactionContextInterface, Msg string, Policy string) error {
	var Message1 Message
	err := json.Unmarshal([]byte(Msg), &Message1)
	if err != nil {
		fmt.Println("Error", err)
	}

	var decoded1 Transaction
	bytes1, _ := hex.DecodeString(string(Message1.Value))
	fmt.Println("bytes", bytes1)
	dec1 := gob.NewDecoder(bytes.NewBuffer(bytes1))
	err = dec1.Decode(&decoded1)
	if err != nil {
		log.Fatal("decode error:", err.Error())
	}

	fmt.Println("tranx", decoded1)
	car := Car{
		Make:   decoded1.PatientNumber,
		Model:  decoded1.Email,
		Colour: decoded1.Adhar,
		Owner:  decoded1.Disease,
	}

	carAsBytes, _ := json.Marshal(car)
	fmt.Println(decoded1.PatientNumber)
	return ctx.GetStub().PutState(decoded1.PatientNumber, carAsBytes)
}

func (s *SmartContract) CreateRecord(ctx contractapi.TransactionContextInterface, Msg string, Policy string) error {
	var Message1 map[string]string
	err := json.Unmarshal([]byte(Msg), &Message1)
	if err != nil {
		fmt.Println("Error", err)
	}

	var decoded1 map[string]string
	bytes1, _ := hex.DecodeString(string(Message1["Value"]))
	fmt.Println("bytes", bytes1)
	dec1 := gob.NewDecoder(bytes.NewBuffer(bytes1))
	err = dec1.Decode(&decoded1)
	if err != nil {
		log.Fatal("decode error:", err.Error())
	}

	fmt.Println("tranx", decoded1)

	carAsBytes, _ := json.Marshal(decoded1)
	fmt.Println("Record Data", decoded1)
	fmt.Println(decoded1["Email"])
	return ctx.GetStub().PutState(decoded1["Email"], carAsBytes)
}

// QueryCar returns the car stored in the world state with given id
func (s *SmartContract) QueryCar(ctx contractapi.TransactionContextInterface, carNumber string) (*Car, error) {
	carAsBytes, err := ctx.GetStub().GetState(carNumber)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if carAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", carNumber)
	}

	car := new(Car)
	_ = json.Unmarshal(carAsBytes, car)

	return car, nil
}

// QueryAllCars returns all cars found in world state
func (s *SmartContract) QueryAllCars(ctx contractapi.TransactionContextInterface) ([]QueryResult, error) {
	startKey := ""
	endKey := ""

	resultsIterator, err := ctx.GetStub().GetStateByRange(startKey, endKey)

	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	results := []QueryResult{}

	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()

		if err != nil {
			return nil, err
		}

		car := new(Car)
		_ = json.Unmarshal(queryResponse.Value, car)

		queryResult := QueryResult{Key: queryResponse.Key, Record: car}
		results = append(results, queryResult)
	}

	return results, nil
}

// ChangeCarOwner updates the owner field of car with given id in world state
func (s *SmartContract) ChangeCarOwner(ctx contractapi.TransactionContextInterface, carNumber string, newOwner string) error {
	car, err := s.QueryCar(ctx, carNumber)

	if err != nil {
		return err
	}

	car.Owner = newOwner

	carAsBytes, _ := json.Marshal(car)

	return ctx.GetStub().PutState(carNumber, carAsBytes)
}

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error create fabcar chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting fabcar chaincode: %s", err.Error())
	}
}
