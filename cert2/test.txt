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
    
#!/bin/bash

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
  -passin pass:peter

# Generate Intermediate CA private key and certificate
openssl genpkey -algorithm RSA -out ./ca/intermediate/private/intermediate-ca_client.key 
#-aes256 -pass pass:peter
openssl genpkey -algorithm RSA -out ./ca/intermediate/private/intermediate-ca_server.key
# -aes256 -pass pass:peter

openssl req -key ./ca/intermediate/private/intermediate-ca_client.key \
  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=intermediate_client" \
  -new -out ./ca/intermediate/intermediate-ca_client.csr   -passin pass:peter
openssl req -key ./ca/intermediate/private/intermediate-ca_server.key \
  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=intermediate_server" \
  -new -out ./ca/intermediate/intermediate-ca_server.csr    -passin pass:peter


# Sign the Intermediate CA CSR with the Root CA certificate
openssl x509 -req -in ./ca/intermediate/intermediate-ca_client.csr \
  -out ./ca/intermediate/cacert_client.pem \
  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=intermediate-ca_client" \
  -CA ./ca/cacert.pem -CAkey ./ca/private/root-ca.key \
  -CAcreateserial -days 3650 -sha256 -passin pass:peter

openssl x509 -req -in ./ca/intermediate/intermediate-ca_server.csr \
  -out ./ca/intermediate/cacert_server.pem \
  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=intermediate-ca_server" \
  -CA ./ca/cacert.pem -CAkey ./ca/private/root-ca.key \
  -CAcreateserial -days 3650 -sha256 -passin pass:peter

# Generate leaf certs (python script instead)

#openssl genpkey -algorithm RSA -out client.key
# -aes256 -pass pass:peter
#openssl genpkey -algorithm RSA -out server.key
# -aes256 -pass pass:peter

#openssl req -new -key client.key  \
#  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=client" \
# -out client.csr -passin pass:peter

#openssl req -new -key server.key \
#  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=server" \
#-out server.csr -passin pass:peter


#INTERMED_CRT=./ca/intermediate/cacert_client.pem 
#INTERMED_KEY=./ca/intermediate/private/intermediate-ca_client.key

#openssl x509 -req -in client.csr -CA $INTERMED_CRT \
#  -CAkey $INTERMED_KEY -CAcreateserial \
#  -config "../../../tools/certs/localhost.cnf" \
#  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=client" \
#  -out ./client.crt -days 365 -sha256 -passin pass:peter

#INTERMED_CRT=./ca/intermediate/cacert_server.pem 
#INTERMED_KEY=./ca/intermediate/private/intermediate-ca_server.key

#openssl x509 -req -in server.csr -CA $INTERMED_CRT \
#  -CAkey $INTERMED_KEY  -CAcreateserial \
#  -extfile "../../../tools/certs/localhost.cnf" \
# -extensions v3_usr_cert
#  -subj "/C=US/ST=California/L=San Francisco/O=MyOrg/OU=MyUnit/CN=server" \
#  -out ./server.crt -days 365 -sha256 -passin pass:peter


#openssl rsa -in server.key -outform DER -out server_key.der
#openssl x509 -in server.crt -outform DER -out server_cert.der

#openssl rsa -in client.key -outform DER -out client_key.der
#openssl x509 -in client.crt -outform DER -out client_cert.der


echo "Intermediate CA certificate generated successfully!"


INTERMED_CRT=./ca/intermediate/cacert_client.pem 
INTERMED_KEY=./ca/intermediate/private/intermediate-ca_client.key
python signed.py --signing_cert $INTERMED_CRT --signing_key $INTERMED_KEY --certificatename client

INTERMED_CRT=./ca/intermediate/cacert_server.pem 
INTERMED_KEY=./ca/intermediate/private/intermediate-ca_server.key
python signed.py --signing_cert $INTERMED_CRT --signing_key $INTERMED_KEY --certificatename server


##################### COPY FILES...

EXAMPLES=~/GitHub/open62541/bin/examples
APP=~/GitHub/open62541/bin/examples/cert_store/ApplCerts
USER=~/GitHub/open62541/bin/examples/cert_store/UserTokenCerts

# Convert 
openssl x509 -in ./ca/intermediate/cacert_server.pem -outform DER -out ./intermediate.der

# Copy both, as I don't have separate auth-cert
cp ./intermediate.der "${EXAMPLES}/"
cp ./intermediate.der "$APP/issuer/certs"
cp ./intermediate.der "$USER/issuer/certs"

cp ./client_cert.der "$APP/trusted/certs"
cp ./client_cert.der "$USER/trusted/certs"

cp server_key.der "${EXAMPLES}/"
cp server_cert.der "${EXAMPLES}/"

cp client_key.der "${EXAMPLES}/"
cp client_cert.der "${EXAMPLES}/"

openssl x509 -in server_cert.der -text -noout
openssl x509 -in client_cert.der -text -noout


echo "Copied all keys and certs"

