#!/bin/bash
set -e

# Base directory for PKI
ROOT_DIR=~/GitHub/open62541/pki

# --------------------------
# Step 0: Create folder structure
# --------------------------
mkdir -p $ROOT_DIR/{certs,private,config,Consilium}
mkdir -p $ROOT_DIR/Consilium/{certs,private,config,C2P-F/{CMB-F,DM-F},C2P-G/{CMB-G,DM-G},Secure-Gateway,SMiG,TMS/{TMS-Display,TMS-Router},Service-Engineer}

# Initialize OpenSSL CA database for Consilium
touch $ROOT_DIR/Consilium/index.txt
echo 1000 > $ROOT_DIR/Consilium/serial

echo "Folder structure and CA database initialized."

# --------------------------
# Step 1: Root CA
# --------------------------
ROOT_KEY=$ROOT_DIR/private/rootCA.key
ROOT_CERT=$ROOT_DIR/certs/rootCA.crt

openssl genrsa -out $ROOT_KEY 4096
openssl req -x509 -new -nodes -key $ROOT_KEY -sha256 -days 7300 \
  -subj "/C=SE/ST=Västra Götaland/L=Gothenburg/O=Consilium AB/OU=PKI/CN=Consilium Root CA" \
  -out $ROOT_CERT

echo "Root CA generated."

# --------------------------
# Step 2: Consilium Intermediate CA
# --------------------------
CONSILIUM_KEY=$ROOT_DIR/Consilium/private/consiliumCA.key
CONSILIUM_CSR=$ROOT_DIR/Consilium/config/consiliumCA.csr
CONSILIUM_CERT=$ROOT_DIR/Consilium/certs/consiliumCA.crt

openssl genrsa -out $CONSILIUM_KEY 4096
openssl req -new -key $CONSILIUM_KEY \
  -subj "/C=SE/ST=Västra Götaland/L=Gothenburg/O=Consilium AB/OU=PKI/CN=Consilium Intermediate CA" \
  -out $CONSILIUM_CSR

# Sign Consilium CA with Root CA
openssl x509 -req -in $CONSILIUM_CSR \
  -CA $ROOT_CERT -CAkey $ROOT_KEY -CAcreateserial \
  -out $CONSILIUM_CERT -days 3650 -sha256

echo "Consilium Intermediate CA generated."

# --------------------------
# Step 3: Function to generate product/device certificates
# --------------------------
generate_cert() {
  BASE_DIR=$1
  NAME=$2
  OU=$3
  DAYS=${4:-730}

  mkdir -p $BASE_DIR/private $BASE_DIR/certs $BASE_DIR/config

  echo "Generating certificate for $NAME ..."

  # Generate private key
  openssl genrsa -out $BASE_DIR/private/$NAME.key 2048

  # Generate CSR
  openssl req -new -key $BASE_DIR/private/$NAME.key \
    -subj "/C=SE/ST=Västra Götaland/L=Gothenburg/O=Consilium AB/OU=$OU/CN=$NAME" \
    -out $BASE_DIR/config/$NAME.csr

  # Sign CSR with Consilium CA
  openssl x509 -req -in $BASE_DIR/config/$NAME.csr \
    -CA $CONSILIUM_CERT -CAkey $CONSILIUM_KEY -CAserial $ROOT_DIR/Consilium/serial \
    -out $BASE_DIR/certs/$NAME.crt -days $DAYS -sha256

  # Copy Consilium CA for chain verification
  cp $CONSILIUM_CERT $BASE_DIR/certs/
}

# --------------------------
# Step 4: Generate all product/device certificates
# --------------------------

# C2P-F
generate_cert $ROOT_DIR/Consilium/C2P-F "C2P-F" "C2P-F" 1825
generate_cert $ROOT_DIR/Consilium/C2P-F/CMB-F "CMB-F" "C2P-F" 730
generate_cert $ROOT_DIR/Consilium/C2P-F/DM-F "DM-F" "C2P-F" 730

# C2P-G
generate_cert $ROOT_DIR/Consilium/C2P-G "C2P-G" "C2P-G" 1825
generate_cert $ROOT_DIR/Consilium/C2P-G/CMB-G "CMB-G" "C2P-G" 730
generate_cert $ROOT_DIR/Consilium/C2P-G/DM-G "DM-G" "C2P-G" 730

# Secure Gateway
generate_cert $ROOT_DIR/Consilium/Secure-Gateway "Secure-Gateway" "Secure-Gateway" 1825

# SMiG
generate_cert $ROOT_DIR/Consilium/SMiG "SMiG" "SMiG" 1825

# TMS
generate_cert $ROOT_DIR/Consilium/TMS "TMS" "TMS" 1825
generate_cert $ROOT_DIR/Consilium/TMS/TMS-Display "TMS-Display" "TMS" 730
generate_cert $ROOT_DIR/Consilium/TMS/TMS-Router "TMS-Router" "TMS" 730

# Service Engineer
generate_cert $ROOT_DIR/Consilium/Service-Engineer "Service-Engineer" "Service-Engineer" 730

echo "All certificates generated successfully."

