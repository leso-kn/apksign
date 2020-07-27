// Copyright © 2020 https://github.com/Leso-KN
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"io/ioutil"
	"path"
	"os"

	"playground/android/apksign"
	"playground/android"
)

//

func loadFile(name string) ([]byte, error) {
	var f *os.File
	var err error
	var b []byte
	if f, err = os.Open(name); err != nil {
		return nil, err
	}
	defer f.Close()
	if b, err = ioutil.ReadAll(f); err != nil {
		return nil, err
	}
	return b, err
}

func saveFile(name string, b []byte) error {
	var f *os.File
	var err error
	if f, err = os.Create(name); err != nil {
		return err
	}
	defer f.Close()
	if _, err = f.Write(b); err != nil {
		return err
	}
	return nil
}

func main() {

	if len(os.Args) < 4 {
		print("Usage: " +  path.Base(os.Args[0]) + " <unsigned.apk> <private.key> <public.crt>\n")
		return
	}

	var filename = os.Args[1]
	var keyfile = os.Args[2]
	var crtfile = os.Args[3]

	//

	var keys []*android.SigningCert = []*android.SigningCert{
		{SigningKey: android.SigningKey{
			KeyPath: keyfile,
			Type:    android.RSA,
			Hash:    android.SHA256,
		},
			CertPath: crtfile,
		},
	}

	var z *apksign.Zip
	var unsapk []byte
	var err error

	if unsapk, err = loadFile(filename); err != nil {
		print("error reading apk.\n")
		return
	}

	if z, err = apksign.NewZip(unsapk); err != nil {
		print("error parsing apk: ", err, "\n")
		return
	}

	// Sign
	if z, err = z.Sign(keys); err != nil {
		print("error signing apk. ", err, "\n")
		return
	}
	if err = z.VerifyV1(); err == nil {
		print("v2-signature apk passed v1 verification.\n")
		return
	}
	if err = z.VerifyV2(); err != nil {
		print("v2-signature verification failed. (1) ", err, "\n")
		return
	}
	if err = z.Verify(); err != nil {
		print("v2-signature verification failed. (2) ", err, "\n")
		return
	}
	if !z.IsAPK || !z.IsV1Signed || !z.IsV2Signed {
		print("signed apk was incorrectly characterized. ", z.IsAPK, z.IsV1Signed, z.IsV2Signed, "\n")
		return
	}

	saveFile(filename, z.Bytes())
}
