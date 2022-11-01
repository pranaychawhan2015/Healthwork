package main

import (
	"crypto/rand"
	"fmt"
	"math/big"

	rand1 "math/rand"

	"strings"
	"time"

	"crypto/ecdsa"
	"encoding/json"

	// "reflect"

	"github.com/fentec-project/bn256"
	"github.com/fentec-project/gofe/data"
	"github.com/fentec-project/gofe/sample"
	"golang.org/x/exp/maps"
)

type cps struct {
	P *big.Int // order of the elliptic curve
}

// NewFAME configures a new instance of the scheme.
func newcps() *cps {

	return &cps{P: bn256.Order}
}

// FAMESecKey represents a master secret key of a FAME scheme.
type cpsSecKey struct {
	PartInt [4]*big.Int
	PartG1  [3]*bn256.G1
}

// FAMEPubKey represents a public key of a FAME scheme.
type cpsPubKey struct {
	PartG2 [2]*bn256.G2
	PartGT [2]*bn256.GT
}
type MSP struct {
	P           *big.Int
	Mat         data.Matrix
	RowToAttrib []string
}
type person struct {
	name string
	age  int
}

func main() {

}

func bigFib(n int) *big.Int {

	return big.NewInt(int64(n))
}

func (a *cps) GenerateMasterKeys() (*cpsPubKey, *cpsSecKey, error) {
	sampler := sample.NewUniformRange(big.NewInt(1), a.P)
	val, err := data.NewRandomVector(7, sampler)
	if err != nil {
		return nil, nil, err
	}

	partInt := [4]*big.Int{val[0], val[1], val[2], val[3]}
	partG1 := [3]*bn256.G1{new(bn256.G1).ScalarBaseMult(val[4]),
		new(bn256.G1).ScalarBaseMult(val[5]),
		new(bn256.G1).ScalarBaseMult(val[6])}
	partG2 := [2]*bn256.G2{new(bn256.G2).ScalarBaseMult(val[0]),
		new(bn256.G2).ScalarBaseMult(val[1])}
	tmp1 := new(big.Int).Mod(new(big.Int).Add(new(big.Int).Mul(val[0], val[4]), val[6]), a.P)
	tmp2 := new(big.Int).Mod(new(big.Int).Add(new(big.Int).Mul(val[1], val[5]), val[6]), a.P)
	partGT := [2]*bn256.GT{new(bn256.GT).ScalarBaseMult(tmp1),
		new(bn256.GT).ScalarBaseMult(tmp2)}

	return &cpsPubKey{PartG2: partG2, PartGT: partGT},
		&cpsSecKey{PartInt: partInt, PartG1: partG1}, nil
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

func BooleanToMSP(boolExp string, convertToOnes bool) (*MSP, error) {
	// by the Lewko-Waters algorithm we obtain a MSP struct with the property
	// that is the the boolean expression is satisfied if and only if the corresponding
	// rows of the msp matrix span the vector [1, 0,..., 0]
	vec := make(data.Vector, 1)
	vec[0] = big.NewInt(1)
	msp, _, err := booleanToMSPIterative(boolExp, vec, 1)
	if err != nil {
		return nil, err
	}

	// if convertToOnes is set to true convert the matrix to such a MSP
	// struct so that the boolean expression is satisfied iff the
	// corresponding rows span the vector [1, 1,..., 1]
	if convertToOnes {
		// create an invertible matrix that maps [1, 0,..., 0] to [1,1,...,1]
		invMat := make(data.Matrix, len(msp.Mat[0]))
		for i := 0; i < len(msp.Mat[0]); i++ {
			invMat[i] = make(data.Vector, len(msp.Mat[0]))
			for j := 0; j < len(msp.Mat[0]); j++ {
				if i == 0 || j == i {
					invMat[i][j] = big.NewInt(1)
				} else {
					invMat[i][j] = big.NewInt(0)
				}
			}
		}
		//change the msp matrix by multiplying with it the matrix invMat
		msp.Mat, err = msp.Mat.Mul(invMat)
		if err != nil {
			return nil, err
		}
	}

	return msp, nil
}
func booleanToMSPIterative(boolExp string, vec data.Vector, c int) (*MSP, int, error) {
	boolExp = strings.TrimSpace(boolExp)
	numBrc := 0
	var boolExp1 string
	var boolExp2 string
	var c1 int
	var cOut int
	var msp1 *MSP
	var msp2 *MSP
	var err error
	found := false

	// find the main AND or OR gate and iteratively call the function on
	// both the sub-expressions
	for i, e := range boolExp {
		if e == '(' {
			numBrc++
			continue
		}
		if e == ')' {
			numBrc--
			continue
		}
		if numBrc == 0 && i < len(boolExp)-3 && boolExp[i:i+3] == "AND" {
			boolExp1 = boolExp[:i]
			boolExp2 = boolExp[i+3:]
			vec1, vec2 := makeAndVecs(vec, c)
			msp1, c1, err = booleanToMSPIterative(boolExp1, vec1, c+1)
			if err != nil {
				return nil, 0, err
			}
			msp2, cOut, err = booleanToMSPIterative(boolExp2, vec2, c1)
			if err != nil {
				return nil, 0, err
			}
			found = true
			break
		}
		if numBrc == 0 && i < len(boolExp)-2 && boolExp[i:i+2] == "OR" {
			boolExp1 = boolExp[:i]
			boolExp2 = boolExp[i+2:]
			msp1, c1, err = booleanToMSPIterative(boolExp1, vec, c)
			if err != nil {
				return nil, 0, err
			}
			msp2, cOut, err = booleanToMSPIterative(boolExp2, vec, c1)
			if err != nil {
				return nil, 0, err
			}
			found = true
			break
		}
	}

	// If the AND or OR gate is not found then there are two options,
	// either the whole expression is in brackets, or the the expression
	// is only one attribute. It neither of both is true, then
	// an error is returned while converting the expression into an
	// attribute
	if !found {
		if boolExp[0] == '(' && boolExp[len(boolExp)-1] == ')' {
			boolExp = boolExp[1:(len(boolExp) - 1)]
			return booleanToMSPIterative(boolExp, vec, c)
		}

		if strings.Contains(boolExp, "(") || strings.Contains(boolExp, ")") {
			return nil, 0, fmt.Errorf("bad boolean expression or attributes contain ( or )")
		}

		mat := make(data.Matrix, 1)
		mat[0] = make(data.Vector, c)
		for i := 0; i < c; i++ {
			if i < len(vec) {
				mat[0][i] = new(big.Int).Set(vec[i])
			} else {
				mat[0][i] = big.NewInt(0)
			}
		}

		rowToAttribS := make([]string, 1)
		rowToAttribS[0] = boolExp
		return &MSP{Mat: mat, RowToAttrib: rowToAttribS}, c, nil

	}
	// otherwise we join the two msp structures into one
	mat := make(data.Matrix, len(msp1.Mat)+len(msp2.Mat))
	for i := 0; i < len(msp1.Mat); i++ {
		mat[i] = make(data.Vector, cOut)
		for j := 0; j < len(msp1.Mat[0]); j++ {
			mat[i][j] = msp1.Mat[i][j]
		}
		for j := len(msp1.Mat[0]); j < cOut; j++ {
			mat[i][j] = big.NewInt(0)
		}
	}
	for i := 0; i < len(msp2.Mat); i++ {
		mat[i+len(msp1.Mat)] = msp2.Mat[i]
	}
	rowToAttribS := append(msp1.RowToAttrib, msp2.RowToAttrib...)

	return &MSP{Mat: mat, RowToAttrib: rowToAttribS}, cOut, nil
}

func makeAndVecs(vec data.Vector, c int) (data.Vector, data.Vector) {
	vec1 := data.NewConstantVector(c+1, big.NewInt(0))
	vec2 := data.NewConstantVector(c+1, big.NewInt(0))
	for i := 0; i < len(vec); i++ {
		vec2[i].Set(vec[i])
	}
	vec1[c] = big.NewInt(-1)
	vec2[c] = big.NewInt(1)

	return vec1, vec2
}
