# Open65421 - Learning!
https://github.com/junkmejl63/open62541.git
cmake-gui to make examples

**python/env**
python -m venv venv
source venv/bin/activate
pip install netifaces
pip install pycryptodome

# Objectives
- Förstå kommunikationsmodellen
- Förstå certifikat, vad som krävs inuti för funktion
- Access nivåer/levels
- Authentication vs. x.509 + mixs certs
- Certificates, keys and it's usage...
- What is mandatory
- Should we use pkcs#11?
- Trustlist, or trust-dir?


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
make -j$(nproc)

cmake -DUA_BUILD_EXAMPLES=ON -DUA_ENABLE_ENCRYPTION=OPENSSL ..


**buld test_certs examples**
bin
In server,
python3 ../../tools/certs/create_self-signed.py -u urn:open62541.unconfigured.application -c server

In client,
python3 ../../tools/certs/create_self-signed.py -u urn:open62541.unconfigured.application -c client
**execute examples**

```
Also test wihtg internediate; intermediate.der
./client_encryption opc.tcp://pege:4840 client_cert.der client_key.der server_cert.der --serverCert server_cert.der

./client_encryption opc.tcp://pege:4840 client_cert.der client_key.der --serverCert server_cert.der
#<trustlist1> 

./server_encryption server_cert.der server_key.der --onlySecure

./server_encryption server_cert.der server_key.der client_cert.der --onlySecure
#[<trustlist1.crl>
#]  [--allowDiscovery]

server_encryption_filestore server_cert.der server_key.der ./cert_store

mkdir ./cert_store/UserTokenCerts/trusted/certs/
cp client_cert.der ./cert_store/UserTokenCerts/trusted/certs/

```




# JSON config
//    {
//      policy: "http://opcfoundation.org/UA/SecurityPolicy#Aes256_Sha256_RsaPss"",
//      certificate: "/path/to/certificate",
//      privateKey: "/path/to/privateKey"
//    }
