# Open65421 - Learning!
https://github.com/junkmejl63/open62541.git
https://www.open62541.org/doc/open62541-master.pdf
cmake-gui to make examples

# Notes on the open65421
- Om 

# Setting it up *python/env*
```
python -m venv venv
source venv/bin/activate
pip install netifaces
pip install pycryptodome
```

# 1. Objectives
- Förstå kommunikationsmodellen
- Förstå certifikat, vad som krävs inuti cert för att fungera
- Access nivåer/levels
- Authentication vs. x.509 + mixs certs
- Certificates, keys and it's usage, parameters
- What is mandatory
- Should we use pkcs#11?
- Trustlist, or trust-dir?
Q: Vilken security poilicy är tänkt att avnändas?

## 1.2 Content in cert
Example: If a client connects to secure.myservice.com:65421, the certificate should have CN=secure.myservice.com.

Verkar kräva IP-addr, samt vissa andra parameter
- It seems that 


# Generate Certificates

**The test-cert is generated using**
```
X509v3 Key Usage: 
    Digital Signature, Non Repudiation, Key Encipherment, Data Encipherment, Certificate Sign
X509v3 Extended Key Usage: 
    TLS Web Server Authentication, TLS Web Client Authentication
X509v3 Subject Alternative Name: 
    DNS:pege, DNS:pege, IP Address:10.0.2.15, IP Address:172.17.0.1, URI:urn:open62541.unconfigured.application
```
**Certs are created in tools/cert folder, and uses localhost.cnf**

NOTE:
- It adds current hostname = ${ENV::HOSTNAME}, IP-Address, and URI
- Q: How should that translate?


# Usage of Certs and encryption

Notes:
- OPC-UA standard mandates DER, but open65421 + openssl/mbedtls seems to be able to manage PEM transparently


Seems to be possible to use 
To use cert we need: UA_ENABLE_ENCRYPTION, and potentially UA_ENABLE_ENCRYPTION_MBEDTLS

If PEM-cert is password protected, privateKeyPasswordCallback is called

```
 # if defined(UA_ENABLE_ENCRYPTION_OPENSSL) || defined(UA_ENABLE_ENCRYPTION_MBEDTLS)

```

For plugin cert
This is only a plugin stuff
typedef enum {
    UA_CERTIFICATEFORMAT_DER,
    UA_CERTIFICATEFORMAT_PEM
} UA_CertificateFormat; 




# Basic authentication

**Client**
 UA_StatusCode retval = UA_Client_connectUsername(client, "opc.tcp://localhost:4840", "paula", "paula123");


**Server**
static UA_UsernamePasswordLogin userNamePW[2] = {
    {UA_STRING_STATIC("peter"), UA_STRING_STATIC("peter123")},
    {UA_STRING_STATIC("paula"), UA_STRING_STATIC("paula123")}
};

    UA_AccessControl_default(config, allowAnonymous, &encryptionPolicy, 2, userNamePW);

# certificates and keys

## Client_encryption:
    UA_ClientConfig_setDefaultEncryption(config, certificate, privateKey,
                                         trustList, trustListSize,
                                         revocationList, revocationListSize);
    UA_AccessControl_default(config, allowAnonymous, &encryptionPolicy, 2, userNamePW);


## server_encryption.c 
Need to provide certificates abd a trustlist.
Only "filestore" takes storePath, and 
Takes a crt

UA_CertificateGroup_Filestore


**Certificate and key setup:**

These are the key topics for certs and keys...
- certificate = loadFile(argv[1]);
- privateKey = loadFile(argv[2]);
- It's assume that these keys are not password protected?
- trustList[i] = loadFile(argv[i+3]);
- issuerList = NULL;
- revocationList = NULL;
- in onlysecure:
- retval = UA_ServerConfig_setDefaultWithSecureSecurityPolicies(config, 4840,
                                                                      &certificate, &privateKey,
                                                                      trustList, trustListSize,
                                                                      issuerList, issuerListSize,
                                                                      revocationList, revocationListSize);

Notes file_enc.c:
- If they have to few arguments, they create dummy certs..
- Trustlist is hard-coded argc-3
- Bug, it stragenly handles the number of trustlists (as we can have --certonly)

# server_encryption_filestore.c
Need to provide a certs, and a cert-file-path

**Certificate and key setup:**
- certificate = loadFile(argv[1]);
- privateKey = loadFile(argv[2]);
- UA_ServerConfig_setDefaultWithFilestore(config, 4840, &certificate, &privateKey, storePath);


# TPM/PKCS#11
Det finns också en pkcs11 koppling kan bli aktuellt.






# Exxample testing

**build examples**
cd ../../
mkdir build && cd build
cmake -DUA_BUILD_EXAMPLES=ON -DUA_ENABLE_PUBSUB=ON -DUA_ENABLE_ENCRYPTION=OPENSSL ..
# -DUA_ENABLE_ENCRYPTION_TPM2=ON ..
cd ..?
make -j$(nproc)

cmake -DUA_BUILD_EXAMPLES=ON -DUA_ENABLE_ENCRYPTION=OPENSSL ..
make -j$(nproc)


## Build test_certs examples
in bin/examples (for simplicity

For server and client
```
python3 ../../tools/certs/create_self-signed.py -u urn:open62541.unconfigured.application -c server

python3 ../../tools/certs/create_self-signed.py -u urn:open62541.unconfigured.application -c client

#Also copy to cert store / App/User
```

# Use the encryption 
```
# Also test with internediate; intermediate.der
./client_encryption opc.tcp://pege:4840 client_cert.der client_key.der server_cert.der --serverCert server_cert.der
#
./client_encryption opc.tcp://pege:4840 client_cert.der client_key.der --serverCert server_cert.der
#<trustlist1> 

# It seems that trustedcrl must be pem?
./server_encryption server_cert^Cer client_cert.pem --onlySecure

#  certificate [1], privateKey [2] trustlist --onlySecure --allowDiscovery
./server_encryption server_cert.der server_key.der --onlySecure

./server_encryption server_cert.der server_key.der client_cert.der --onlySecure
#[<trustlist1.crl>
#]  [--allowDiscovery]

server_encryption_filestore server_cert.der server_key.der ./cert_store

mkdir ./cert_store/UserTokenCerts/trusted/certs/

NONE
rm ./cert_store/UserTokenCerts/trusted/certs/client_cert.der
rm ./cert_store/ApplCerts/trusted/certs/client_cert.der

BOTH
cp client_cert.der ./cert_store/UserTokenCerts/trusted/certs/
cp client_cert.der ./cert_store/ApplCerts/trusted/certs/
-info/client	Client Status: ChannelState: Open, SessionState: Activated, ConnectStatus: Good


ONLY APP
rm ./cert_store/UserTokenCerts/trusted/certs/client_cert.der
cp client_cert.der ./cert_store/ApplCerts/trusted/certs/
- error/client	Session cannot be activated with StatusCode BadIdentityTokenRejected.

ONLY USER
cp client_cert.der ./cert_store/UserTokenCerts/trusted/certs/
rm ./cert_store/ApplCerts/trusted/certs/client_cert.der
error/channel	TCP 6	| SC 0	| Received an ERR response with StatusCode BadSecurityChecksFailed 
```



# JSON config
//    {
//      policy: "http://opcfoundation.org/UA/SecurityPolicy#Aes256_Sha256_RsaPss"",
//      certificate: "/path/to/certificate",
//      privateKey: "/path/to/privateKey"
//    }

