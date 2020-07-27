# `apksign`

Go based tool for signing android apks with [Apk v2 sign](https://source.android.com/security/apksigning/v2).

Credits go to [morrildl](https://github.com/morrildl). The mechanism used in this tool was implemented in their [playground-android](https://github.com/morrildl/playground-android) repository.

## Usage

```sh
> apktool <unsigned.apk> <private.key> <public.crt>
```

## Building

```sh
> make
```

or

```sh
> make deps # Download dependencies
> go build
```

If you want to run the tool without compiling it you may also go for
```sh
> make deps # Download dependencies
> go run main.go
```

## About Certificates

Unlike `jarsigner` this tool uses a pair of public and private key instead of a java keystore.

You can generate a key pair [using openssl](https://www.tutorialspoint.com/how-to-use-openssl-for-generating-ssl-certificates-private-keys-and-csrs).