# CERT and code stuff
cert_store/
├── ApplCerts
│   ├── issuer
│   │   ├── certs
│   │   └── crl
│   ├── own
│   │   ├── certs
│   │   └── private
│   ├── rejected
│   │   └── certs
│   │       └── open62541Server@localhost[D4828682F13338D3C11A584EA3A6D8765F49E0AA]
│   └── trusted
│       ├── certs
│       │   └── client_cert.der
│       └── crl
└── UserTokenCerts
    ├── issuer
    │   ├── certs
    │   └── crl
    ├── own
    │   ├── certs
    │   └── private
    ├── rejected
    │   └── certs
    │       └── open62541Server@localhost[9F759E9CD63F148A45B9FD2E80E8C59CF0628799]
    └── trusted
        ├── certs
        │   └── client_cert.der
        └── crl



# Test cert:


```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            65:b8:af:46:7a:e7:5e:fc:cb:94:e3:e4:fd:be:6c:bf:56:87:c9:2d
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = DE, L = Here, O = open62541, CN = open62541Server@localhost
        Validity
            Not Before: Jan  7 10:33:30 2026 GMT
            Not After : Jan  7 10:33:30 2027 GMT
        Subject: C = DE, L = Here, O = open62541, CN = open62541Server@localhost
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:d4:8a:2f:c4:98:0d:3c:8b:dd:ac:38:16:1d:25:
                    ee:16:01:46:c2:c3:51:14:00:a3:db:e7:eb:d8:cc:
                    f5:26:a9:c9:32:25:a2:63:4b:c1:c1:1b:25:62:f3:
                    d5:0a:1c:d9:f3:b0:6e:27:14:88:2b:fe:45:cd:2f:
                    60:b3:c7:20:64:21:a1:b1:6d:08:f2:9d:2e:af:0a:
                    eb:0b:ac:92:31:02:90:6e:63:06:80:52:9c:44:55:
                    64:a9:2b:a5:85:ca:ad:e1:d4:19:f0:0d:32:f1:2b:
                    27:8a:1f:89:ec:c6:87:80:0b:f1:78:79:ab:f1:1e:
                    5d:5d:0e:c3:33:74:f7:1c:d6:9d:b0:23:c9:6c:ac:
                    2b:73:27:7a:f7:bc:30:3a:7b:39:b4:e2:ae:38:82:
                    5d:6c:5c:b5:90:0d:c7:bd:06:35:c5:19:a2:82:57:
                    46:fd:e5:f3:50:75:bd:f1:d0:c6:26:c8:20:4b:d1:
                    92:7b:1c:bd:de:23:06:72:ae:5a:f9:13:eb:34:a7:
                    55:ef:d4:4e:f3:15:93:9c:8d:1d:f6:1d:7a:1a:49:
                    3a:fb:79:6d:f7:5c:af:13:e4:27:64:c6:d1:61:2f:
                    69:c3:22:a2:b7:9e:1f:b2:09:4b:5f:54:d4:1c:8d:
                    03:48:cd:85:8a:bd:94:d2:30:26:ac:67:8b:c9:5b:
                    52:67
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier: 
                BB:32:9D:38:B0:95:77:F5:19:BD:BF:26:5D:E7:7F:34:7A:56:86:8F
            X509v3 Authority Key Identifier: 
                BB:32:9D:38:B0:95:77:F5:19:BD:BF:26:5D:E7:7F:34:7A:56:86:8F
            X509v3 Basic Constraints: 
                CA:FALSE
            X509v3 Key Usage: 
                Digital Signature, Non Repudiation, Key Encipherment, Data Encipherment, Certificate Sign
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 Subject Alternative Name: 
                DNS:pege, DNS:pege, IP Address:10.0.2.15, IP Address:172.17.0.1, URI:urn:open62541.unconfigured.application
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        af:0c:5c:e2:40:cd:66:08:09:fe:ef:6f:8d:39:62:ed:67:4c:
        06:05:05:94:3c:42:99:05:ee:58:fa:7f:66:82:3c:8d:09:8b:
        74:cc:a7:a6:55:fc:f5:77:ce:b6:4e:22:22:a3:e5:65:d7:e3:
        5e:eb:69:4c:c6:c1:5c:3a:ca:1a:48:66:fc:f0:99:f9:9a:8f:
        35:a3:ac:9f:52:2e:f9:c2:38:0f:12:9b:ee:3b:f6:98:12:8d:
        49:89:5c:b2:56:e2:da:62:23:90:0f:13:9b:6d:f6:9a:68:9b:
        65:65:ff:7d:8f:79:98:fd:df:70:17:46:74:01:b8:72:15:cd:
        5a:b5:25:a7:19:4e:ed:7c:78:c3:a6:f1:ef:5e:02:26:b9:36:
        92:34:b9:06:79:fb:eb:89:91:91:70:b0:9b:b1:52:c5:66:62:
        6c:78:77:35:98:c4:c3:96:e1:60:a9:a2:1c:24:a8:97:03:d4:
        1d:78:83:1d:e4:65:1c:92:38:6b:00:16:96:c3:27:1c:03:b2:
        32:65:62:eb:22:7c:aa:90:64:55:a9:1f:af:07:c8:17:15:10:
        55:1e:62:ea:d4:d1:f9:0d:59:e3:fe:be:c9:a0:ef:c7:32:39:
        cb:5f:ad:db:c7:80:13:f4:d5:c1:5d:77:93:88:75:e4:c0:dd:
        7e:a5:eb:79
```


# Security policieis / 
**crypto-suites**
- BASIC256SHA1
- ECCNISTP256
- AES128SHA256RSAOAEP
- AES256SHA256RSAPSS
- BASIC128RSA15 (Derived:128bit, RSA:1024-2048, Nonce: 16B)
- BASIC128RSA15_RSA (SHA1, RSA=?)
- BASIC256SHA256_RSA (2048-4096)


```e
#define UA_SECURITYPOLICY_BASIC128RSA15_RSAPADDING_LEN 11
#define UA_SECURITYPOLICY_BASIC128RSA15_SYM_KEY_LENGTH 16
#define UA_BASIC128RSA15_SYM_SIGNING_KEY_LENGTH 16
#define UA_SECURITYPOLICY_BASIC128RSA15_SYM_ENCRYPTION_BLOCK_SIZE 16
#define UA_SECURITYPOLICY_BASIC128RSA15_SYM_PLAIN_TEXT_BLOCK_SIZE 16
#define UA_SECURITYPOLICY_BASIC128RSA15_MINASYMKEYLENGTH 128
define UA_SECURITYPOLICY_BASIC128RSA15_MAXASYMKEYLENGTH 512
```
Note: This is same for all policies..

- PKCS#1.5? (RSA15?)

 size_t keylen = mbedtls_rsa_get_len(rsaContext); // Returns BYTES...

 if(rsaContext->len < UA_SECURITYPOLICY_BASIC128RSA15_MINASYMKEYLENGTH ||
       rsaContext->len > UA_SECURITYPOLICY_BASIC128RSA15_MAXASYMKEYLENGTH)
        return UA_STATUSCODE_BADCERTIFICATEUSENOTALLOWED;
#else
    size_t keylen = mbedtls_rsa_get_len(mbedtls_pk_rsa(cc->remoteCertificate.pk));
    if(keylen < UA_SECURITYPOLICY_BASIC128RSA15_MINASYMKEYLENGTH ||
       keylen > UA_SECURITYPOLICY_BASIC128RSA15_MAXASYMKEYLENGTH)
        return UA_STATUSCODE_BADCERTIFICATEUSENOTALLOWED;


#define UA_SECURITYPOLICY_BASIC128RSA15_RSAPADDING_LEN 11
#define UA_SECURITYPOLICY_BASIC128RSA15_SYM_KEY_LENGTH 16
#define UA_BASIC128RSA15_SYM_SIGNING_KEY_LENGTH 16
#define UA_SECURITYPOLICY_BASIC128RSA15_SYM_ENCRYPTION_BLOCK_SIZE 16
#define UA_SECURITYPOLICY_BASIC128RSA15_SYM_PLAIN_TEXT_BLOCK_SIZE 16
#define UA_SECURITYPOLICY_BASIC128RSA15_MINASYMKEYLENGTH 128
#define UA_SECURITYPOLICY_BASIC128RSA15_MAXASYMKEYLENGTH 512        


UA_TRUSTLISTMASKS_TRUSTEDCERTIFICATES <= onlysecure
plugins/crypto/openssl/securitypolicy_basic256sha256

# Proto9col
XLDSGI=
https://profiles.opcfoundation.org/profile/1532


# OPC-UA in a nutshell
- Have permissions
-  admin,settings,
- access levels, 
- password managemetn,...

/* Different sets of certificates are trusted for SecureChannel / Session */
UA_CertificateGroup secureChannelPKI;
UA_CertificateGroup sessionPKI;

- #ifdef UA_ENABLE_ENCRYPTION

/* Connect to the server and create+activate a Session with the given username
* and password. This first set the UserIdentityToken in the client config and
* then calls the regular connect method. */
UA_StatusCode UA_THREADSAFE
UA_Client_connectUsername(UA_Client *client, const char *endpointUrl,
const char *username, const char *password);
/* Connect to the server with a SecureChannel, but without creating a Session */
UA_StatusCode UA_THREADSAFE
UA_Client_connectSecureChannel(UA_Client *client, const char *endpointUrl);
/


# Certificate management / validation 
3.5 CertificateGroup Plugin API
This plugin verifies that the origin of the certificate is trusted. It does not assign any access rights/roles
to the holder of the certificate.
Usually, implementations of the CertificateGroup plugin provide an initialization method that takes
a trust-list and a revocation-list as input. 


4.8.23 TrustListMasks
typedef enum {
UA_TRUSTLISTMASKS_NONE = 0,
UA_TRUSTLISTMASKS_TRUSTEDCERTIFICATES = 1,
UA_TRUSTLISTMASKS_TRUSTEDCRLS = 2,
UA_TRUSTLISTMASKS_ISSUERCERTIFICATES = 4,
UA_TRUSTLISTMASKS_ISSUERCRLS = 8,
UA_TRUSTLISTMASKS_ALL = 15
} UA_TrustListMasks;


# Certificate Validation activities in the stack
* The description must be internally consistent. The ApplicationUri set in
* the ApplicationDescription must match the URI set in the server
* certificate.
* The applicationType is not just descriptive, it changes the actual
* functionality of the server. The RegisterServer service is available only
* if the server is a DiscoveryServer and the applicationType is set to the
* appropriate value.*/


UA_Server_updateCertificate(UA_Server *server,
const UA_NodeId certificateGroupId,
const UA_NodeId certificateTypeId,
const UA_ByteString certificate,
const UA_ByteString *privateKey);
* If certificateGroupId is null the DefaultApplicationGroup is used.
* @param certificateGroupId The NodeId of the certificate group where
* certificates will be added

/* The description must be internally consistent.
* - The ApplicationUri set in the ApplicationDescription must match the
* URI set in the certificate */
UA_ApplicationDescription clientDescription;

/* Certificate Verification Plugin */
UA_CertificateGroup certificateVerification;

/* The certificate does not meet the requirements of the security policy. */
#define UA_STATUSCODE_BADCERTIFICATEPOLICYCHECKFAILED 0x81140000

/* The certificate has expired or is not yet valid. */
#define UA_STATUSCODE_BADCERTIFICATETIMEINVALID 0x80140000
Q: Is it possible to get time before secure channel?


/* An issuer certificate has expired or is not yet valid. */
#define UA_STATUSCODE_BADCERTIFICATEISSUERTIMEINVALID 0x80150000
/* The HostName used to connect to a server does not match a HostName in the␣
˓→certificate. */
#define UA_STATUSCODE_BADCERTIFICATEHOSTNAMEINVALID 0x80160000

/* The URI specified in the ApplicationDescription does not match the URI in the␣
˓→certificate. */
#define UA_STATUSCODE_BADCERTIFICATEURIINVALID 0x80170000

/* The certificate may not be used for the requested operation. */
#define UA_STATUSCODE_BADCERTIFICATEUSENOTALLOWED 0x80180000

/* The issuer certificate may not be used for the requested operation. */
#define UA_STATUSCODE_BADCERTIFICATEISSUERUSENOTALLOWED 0x80190000

/* The certificate is not trusted. */
#define UA_STATUSCODE_BADCERTIFICATEUNTRUSTED 0x801A0000
/* It was not possible to determine if the certificate has been revoked. */
#define UA_STATUSCODE_BADCERTIFICATEREVOCATIONUNKNOWN 0x801B0000
/* It was not possible to determine if the issuer certificate has been revoked. */
#define UA_STATUSCODE_BADCERTIFICATEISSUERREVOCATIONUNKNOWN 0x801C0000
/* The certificate has been revoked. */
#define UA_STATUSCODE_BADCERTIFICATEREVOKED 0x801D0000
/* The issuer certificate has been revoked. */
#define UA_STATUSCODE_BADCERTIFICATEISSUERREVOKED 0x801E0000
/* The certificate chain is incomplete. */
#define UA_STATUSCODE_BADCERTIFICATECHAININCOMPLETE 0x810D0000
/* User does not have permission to perform the requested operation. */
#define UA_STATUSCODE_BADUSERACCESSDENIED 0x801F0000
/* The user identity token is not valid. */
#define UA_STATUSCODE_BADIDENTITYTOKENINVALID 0x80200000
/* The user identity token is valid but the server has rejected it. */
#define UA_STATUSCODE_BADIDENTITYTOKENREJECTED 0x80210000

/* The signature generated with the client certificate is missing or invalid. */
#define UA_STATUSCODE_BADAPPLICATIONSIGNATUREINVALID 0x80580000

/* The client did not provide at least one software certificate that is valid and␣
˓→meets the profile requirements for the server. */
#define UA_STATUSCODE_BADNOVALIDCERTIFICATES 0x80590000


/* Verify that the certificate has the applicationURI in the subject name. */
UA_StatusCode
UA_CertificateUtils_verifyApplicationURI(UA_RuleHandling ruleHandling,
const UA_ByteString *certificate,
const UA_String *app

struct UA_CertificateGroup {

## nodeid !!!
UA_NodeId certificateGroupId;
UA_NodeId certificateTypeId;

/* Shorthand for standard-defined NodeIds in Namespace 0.
* See the generated nodeids.h for the full list. */
#define UA_NS0EXID(ID) UA_EXPANDEDNODEID_NUMERIC(0, UA_NS0ID_##ID)
/* Print the ExpandedNodeId in the humand-readable format defined in Part 6,
* 5.3.1.11:
*
* svr=<serverindex>;ns=<namespaceindex>;<type>=<value>
* or
* svr=<serverindex>;nsu=<uri>;<type>=<value>
*
* The definitions for svr, ns and nsu is omitted if zero / the empty string.
*
* The method can either use a pre-allocated string buffer or allocates memory
* internally if called with an empty output string. */




        UA_LOG_WARNING(logger, UA_LOGCATEGORY_SECURITYPOLICY,
                       "The certificate's Subject Alternative Name URI (%S) "
                       "does not match the ApplicationURI (%S)",
                       subjectURI, *applicationURI);

## NODID
getCertificateGroup(UA_Server *server, const UA_NodeId certificateGroupId) {
    UA_NodeId defaultApplicationGroup =
        UA_NODEID_NUMERIC(0, UA_NS0ID_SERVERCONFIGURATION_CERTIFICATEGROUPS_DEFAULTAPPLICATIONGROUP);
    UA_NodeId defaultUserTokenGroup =
        UA_NODEID_NUMERIC(0, UA_NS0ID_SERVERCONFIGURATION_CERTIFICATEGROUPS_DEFAULTUSERTOKENGROUP);
    if(UA_NodeId_equal(&certificateGroupId, &defaultApplicationGroup)) {
  
#define UA_NS0ID_SERVERCONFIGURATION_CERTIFICATEGROUPS_DEFAULTAPPLICATIONGROUP 14156 /* Object 
#define UA_NS0ID_SERVERCONFIGURATION_CERTIFICATEGROUPS_DEFAULTUSERTOKENGROUP   14122*/  
### SAN:
X509v3 Subject Alternative Name: 
- DNS:pege
- DNS:pege
- IP Address:10.0.2.15
- IP Address:172.17.0.1
- URI:urn:open62541.unconfigured.application



## XXX
* Split the given endpoint url into hostname, vid and pcp. All arguments must
 * be non-NULL. EndpointUrls have the form "opc.eth://<host>[:<VID>[.PCP]]".
 * The host is a MAC address, an IP address or a registered name like a
 * hostname. The format of a MAC address is six groups of hexadecimal digits,
 * separated by hyphens (e.g. 01-23-45-67-89-ab). A system may also accept
 * hostnames and/or IP addresses if it provides means to resolve it to a MAC
 * address (e.g. DNS and Reverse-ARP).
 *
 * Note: currently only parsing MAC address is supported.


Enepoint:url:
"opc.udp://" =>networkaddressurl
"opc.tcp://localhost:4840"
"opc.wss://localhost:443"
"opc.eth"
networkAddressUrl.url = UA_STRING(argv[1]);
opc.eth:// (transportprofile)

## Ohter

/* Different sets of certificates are trusted for SecureChannel / Session */
UA_CertificateGroup secureChannelPKI;
UA_CertificateGroup sessionPKI;



# Implementaiton
I'm using mbedtls, and have not set "mbedtls_x509_subject_alternative_name"


# WArnings
[2026-01-08 15:36:07.955 (UTC+0100)] warn/application	ServerUrls already set. Overriding.
[2026-01-08 15:36:07.955 (UTC+0100)] warn/server	AccessControl: Unconfigured AccessControl. Users have all permissions.
[2026-01-08 15:36:07.955 (UTC+0100)] warn/security	The certificate's application URI could not be verified. StatusCode BadCertificateUriInvalid
[2026-01-08 15:36:07.955 (UTC+0100)] warn/security	The certificate's application URI could not be verified. StatusCode BadCertificateUriInvalid
[2026-01-08 15:36:07.955 (UTC+0100)] warn/security	The certificate's application URI could not be verified. StatusCode BadCertificateUriInvalid

