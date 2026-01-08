#!/bin/bash
set -e

# ./ca/
# ├── private/
# ├── newcerts/
# ├── certs/
# ├── crl/
# ├── intermediate/
# │   ├── private/
# │   └── newcerts/
# ├── client/
# │   └── private/
# └── server/
#     └── private/
    
# Step 1: Create necessary directories
rm -rf ca
mkdir -p ./ca/private ./ca/certs ./ca/newcerts ./ca/crl ./ca/intermediate/private ./ca/intermediate/newcerts ./ca/client/private ./ca/server/private
touch ./ca/database.txt
ls -l ./ca/database.txt


# Step 2: Create index and serial files
touch ./ca/myindex ./ca/serial ./ca/intermediate/myindex
echo 1000 > ./ca/serial
echo 1000 > ./ca/intermediate/serial


# Step 5: Create Client and Server Configurations (if necessary)

# Generate the Root CA private key and certificate
openssl genpkey -algorithm RSA -out ./ca/private/root-ca.key 
#-aes256 -pass pass:peter
openssl req -key ./ca/private/root-ca.key \
  -new -x509 -out ./ca/cacert.pem -days 3650 \
  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=root" \
  -nodes


export IPADDRESS1=127.0.0.1
export IPADDRESS2=127.0.0.1

export HOSTNAME=pege
export URI1="urn:open62541.unconfigured.application"


###### CA ############

# Generate Intermediate CA private key and certificate
openssl genpkey -algorithm RSA -out ./ca/intermediate/private/intermediate-ca_client.key 
#-aes256 -pass pass:peter
openssl genpkey -algorithm RSA -out ./ca/intermediate/private/intermediate-ca_server.key
# -aes256 -pass pass:peter

#V3EXT1="keyUsage=digitalSignature,keyEncipherment"
#V3EXT2="keyUsage=digitalSignature,keyEncipherment"
#basicConstraints = CA:TRUE
#keyUsage = critical, digitalSignature, keyCertSign, cRLSign
#e#xtendedKeyUsage = clientAuth

#  -addext "extendedKeyUsage=serverAuth,clientAuth"

###### INTERMEDIATE CLIENT ############
openssl req -key ./ca/intermediate/private/intermediate-ca_client.key \
  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=intermediate_client" \
  -new -out ./ca/intermediate/intermediate-ca_client.csr   -nodes
#  -config ./intermediate.conf \
#  -extensions v3_intermediate_ca \


# Sign the Intermediate CA CSR with thlse Root CA certificate
openssl x509 -req -in ./ca/intermediate/intermediate-ca_client.csr \
  -out ./ca/intermediate/cacert_client.pem \
  -CA ./ca/cacert.pem -CAkey ./ca/private/root-ca.key \
  -CAcreateserial -days 3650 -sha256 -extensions v3_req \
  -extfile intermediate.conf

###### INTERMEDIATE SERVER ############

openssl req -key ./ca/intermediate/private/intermediate-ca_server.key \
  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=intermediate_server" \
  -new -out ./ca/intermediate/intermediate-ca_server.csr -nodes
#  -config ./intermediate.conf \
#  -extensions v3_intermediate_ca \

# Sign the Intermediate CA CSR with thlse Root CA certificate
openssl x509 -req -in ./ca/intermediate/intermediate-ca_server.csr \
  -out ./ca/intermediate/cacert_server.pem \
  -CA ./ca/cacert.pem -CAkey ./ca/private/root-ca.key \
  -CAcreateserial -days 3650 -sha256 -extensions v3_req \
  -extfile intermediate.conf



# Sign the Intermediate CA CSR with thlse Root CA certificate
#openssl x509 -req -in ./ca/intermediate/intermediate-ca_client.csr \
#  -out ./ca/intermediate/cacert_client.pem \
#  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=intermediate-ca_client" \
 # -CA ./ca/cacert.pem -CAkey ./ca/private/root-ca.key \
#  -config intermediate.conf -extensions v3_intermediate_ca \
#  -CAcreateserial -days 3650 -sha256 -nodes



# Generate leaf certs (python script instead)

#openssl genpkey -algorithm RSA -out client.key
# -aes256 -pass pass:peter
#openssl genpkey -algorithm RSA -out server.key
# -aes256 -pass pass:peter

#openssl req -new -key client.key  \
#  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=client" \
# -out client.csr -nodes

#openssl req -new -key server.key \
#  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=server" \
#-out server.csr -nodes


#INTERMED_CRT=./ca/intermediate/cacert_client.pem 
#INTERMED_KEY=./ca/intermediate/private/intermediate-ca_client.key

#openssl x509 -req -in client.csr -CA $INTERMED_CRT \
#  -CAkey $INTERMED_KEY -CAcreateserial \
#  -config "../../../tools/certs/localhost.cnf" \
#  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=client" \
#  -out ./client.crt -days 365 -sha256 -nodes

#INTERMED_CRT=./ca/intermediate/cacert_server.pem 
#INTERMED_KEY=./ca/intermediate/private/intermediate-ca_server.key

#openssl x509 -req -in server.csr -CA $INTERMED_CRT \
#  -CAkey $INTERMED_KEY  -CAcreateserial \
#  -extfile "../../../tools/certs/localhost.cnf" \
# -extensions v3_usr_cert
#  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=server" \
#  -out ./server.crt -days 365 -sha256 -nodes


#openssl rsa -in server.key -outform DER -out server_key.der
#openssl x509 -in server.crt -outform DER -out server_cert.der

#openssl rsa -in client.key -outform DER -out client_key.der
#openssl x509 -in client.crt -outform DER -out client_cert.der


echo "Intermediate CA certificate generated successfully!"




INTERMED_CRT=./ca/intermediate/cacert_client.pem 
INTERMED_KEY=./ca/intermediate/private/intermediate-ca_client.key
SUBJ=/C=DE/O=open62541/CN=open62541Client@localhost
OUT=./client
if [ 0 -eq 1 ]; then
 python signed.py --signing_cert $INTERMED_CRT \
   --signing_key $INTERMED_KEY \
   --subject $SUBJ \
   --certificatename client
else

openssl req \
 -new -nodes -sha256 \
 -newkey rsa:2048 \
 -keyout "${OUT}_key.pem" \
  -config ./test.conf \
 -subj $SUBJ  \
 -out localhost.csr

openssl ca -batch \
  -keyfile $INTERMED_KEY \
  -cert $INTERMED_CRT \
  -config ./test.conf \
  -in localhost.csr -out "${OUT}_cert.pem"
fi

INTERMED_CRT=./ca/intermediate/cacert_server.pem 
INTERMED_KEY=./ca/intermediate/private/intermediate-ca_server.key
SUBJ=/C=DE/O=open62541/CN=open62541Server@localhost
OUT=./server

if [ 0 -eq 1 ]; then
python signed.py --signing_cert $INTERMED_CRT \
  --signing_key $INTERMED_KEY \
  --subject $SUBJ \
  --certificatename server
else
openssl req \
 -new -nodes -sha256 \
 -newkey rsa:2048 \
 -keyout "${OUT}_key.pem" \
  -config ./test.conf \
 -subj $SUBJ  \
 -out localhost.csr
openssl ca -batch \
  -keyfile $INTERMED_KEY \
  -cert $INTERMED_CRT \
  -config ./test.conf \
  -in localhost.csr -out "${OUT}_cert.pem"
fi

##################### COPY FILE ###########################

EXAMPLES=~/GitHub/open62541/bin/examples
APP=~/GitHub/open62541/bin/examples/cert_store/ApplCerts
USER=~/GitHub/open62541/bin/examples/cert_store/UserTokenCerts

# Convert 
openssl x509 -in ./ca/intermediate/cacert_server.pem -outform DER -out ./intermediate.der

openssl x509 -inform PEM -in client_cert.pem -outform DER -out client_cert.der
openssl x509 -inform PEM -in server_cert.pem -outform DER -out server_cert.der

openssl pkey -in client_key.pem -outform DER -out client_key.der
openssl pkey -in server_key.pem -outform DER -out server_key.der

# Copy both, as I don't have separate auth-cert
cp ./intermediate.der "${EXAMPLES}/"
#cp ./intermediate.der "${APP}/issuer/certs"
#cp ./intermediate.der "$USER/issuer/certs"

cp ./ca/intermediate/cacert_client.pem "${APP}/issuer/certs"
cp ./ca/intermediate/cacert_client.pem "${USER}/issuer/certs"

#cp ./client_cert.der "$APP/trusted/certs"
#cp ./client_cert.der "$USER/trusted/certs"

cp ./client_cert.pem "$APP/trusted/certs"
cp ./client_cert.pem "$USER/trusted/certs"

cp server_key.der "${EXAMPLES}/"
cp server_cert.der "${EXAMPLES}/"

cp client_key.der "${EXAMPLES}/"
cp client_cert.der "${EXAMPLES}/"
cp client_cert.pem "${EXAMPLES}/"

openssl x509 -in server_cert.der -text -noout
openssl x509 -in client_cert.der -text -noout

echo "Copied all keys and certs"

## Verify chain
openssl verify -CAfile ./ca/cacert.pem  -untrusted ./ca/intermediate/cacert_server.pem   ./server_cert.pem 
openssl verify -CAfile ./ca/cacert.pem  -untrusted ./ca/intermediate/cacert_client.pem   ./client_cert.pem 



#openssl verify -crl_check_all -CAfile ./ca/cacert.pem  -untrusted ./ca/intermediate/cacert_server.pem   ./server_cert.pem 


-purpose sslclient



openssl x509 -in ./server_cert.pem  -noout -text
echo #####
openssl x509 -in ./ca/intermediate/cacert_client.pem -noout -text
echo #####
openssl x509 -in ./ca/cacert.pem -noout -text
####
echo "#### form bin/exmaples dir #### "  > cert1.txt
openssl x509 -in server_cert.der -text -noout >> cert1.txt

echo "#### CLIENT #### "  >> cert1.txt
openssl x509 -in client_cert.der -text -noout >> cert1.txt

echo "#### INTERMEDIATE #### "  >> cert1.txt
openssl x509 -in ./ca/intermediate/cacert_client.pem -text -noout >> cert1.txt


echo "#### form tools/certs dir #### "  > cert2.txt
openssl x509 -in ~/GitHub/open62541/tools/certs/server_cert.der -text -noout >> cert2.txt

echo "#### CLIENT #### "  >> cert2.txt
openssl x509 -in ~/GitHub/open62541/tools/certs/client_cert.der -text -noout >> cert2.txt
meld cert1.txt cert2.txt
