#!/bin/bash

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

# Step 2: Create index and serial files
touch ./ca/myindex ./ca/serial ./ca/intermediate/myindex
echo 1000 > ./ca/serial
echo 1000 > ./ca/intermediate/serial

# Step 3: Create Root CA Configuration
cat <<EOF > ./root-ca.conf
[ ca ]
default_ca = CA_default

[ CA_default ]
dir = ./ca
certs = \$dir/certs
crl_dir = \$dir/crl
database = \$dir/myindex
new_<certs_dir = \$dir/newcerts
private_dir = \$dir/private
certificate = \$dir/cacert.pem
serial = \$dir/serial
crlnumber = \$dir/crlnumber
RANDFILE = \$dir/private/.rand
default_md = sha256
preserve = no
policy = policy_match
email_in_dn = no
nameopt = ca_default
certopt = ca_default
copy_extensions = copy
default_days = 3650
default_crl_days = 30

[ req ]
# Default settings for the request
default_bits        = 2048
default_keyfile     = root-ca.key
distinguished_name  = req_distinguished_name
req_extensions      = v3_ca


EOF



# Step 4: Create Intermediate CA Configuration
cat <<EOF > ./ca/intermediate/intermediate-ca.conf
[ ca ]
default_ca = CA_default

[ CA_default ]
dir               = ./ca/intermediate        # Directory for intermediate CA files
certs             = $dir/certs               # Intermediate certificates directory
crl_dir           = $dir/crl                 # CRL directory
database          = $dir/myindex            # Database for intermediate CA
new_certs_dir     = $dir/newcerts           # New intermediate certificates
private_dir       = $dir/private            # Private key directory
certificate       = $dir/cacert.pem         # Intermediate certificate
serial            = $dir/serial             # Serial number file
crlnumber         = $dir/crlnumber          # CRL number file
RANDFILE          = $dir/private/.rand      # Random file for intermediate CA
default_md        = sha256                  # Hashing algorithm
preserve          = no                      # Preserve existing files
policy            = policy_match            # Signing policy
email_in_dn       = no                      # Don't use email in DN
nameopt           = ca_default              # Name options
certopt           = ca_default              # Certificate options
copy_extensions   = copy                    # Copy extensions
default_days      = 3650                    # Validity period for intermediate certificates
default_crl_days  = 30                      # CRL validity

# Extensions for signing intermediate certificates
[ v3_ca ]
basicConstraints = critical,CA:true
keyUsage         = critical,keyCertSign,cRLSign
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer:always
EOF


# Step 5: Create Client and Server Configurations (if necessary)

# Generate the Root CA private key and certificate
openssl genpkey -algorithm RSA -out ./ca/private/root-ca.key -aes256
openssl req -key ./ca/private/root-ca.key -new -x509 -out ./ca/cacert.pem -days 3650 -config ./root-ca.conf

# Generate Intermediate CA private key and certificate
openssl genpkey -algorithm RSA -out ./ca/intermediate/private/intermediate-ca.key -aes256
openssl req -key ./ca/intermediate/private/intermediate-ca.key -new -out ./ca/intermediate/intermediate-ca.csr -config ./ca/intermediate/intermediate-ca.conf

# Sign the Intermediate CA CSR with the Root CA certificate
openssl ca -config ./root-ca.conf -extensions v3_ca -days 3650 -notext -in ./ca/intermediate/intermediate-ca.csr -out ./ca/intermediate/cacert.pem

echo "Intermediate CA certificate generated successfully!"

