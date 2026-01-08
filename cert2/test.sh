export IPADDRESS1=127.0.0.1
export IPADDRESS2=127.0.0.1

export HOSTNAME=pege
export URI1="urn:open62541.unconfigured.application"

openssl req \
 -new -nodes -sha256 \
 -newkey rsa:2048 \
 -keyout localhost.key \
  -config ./localhost.cnf \
 -subj /C=DE/L=Here/O=open62541/CN=open62541Server@localhost \
 -out localhost.csr


openssl ca -batch \
  -keyfile ./ca/intermediate/private/intermediate-ca_server.key \
  -cert ./ca/intermediate/cacert_server.pem \
  -config ./localhost.cnf \
  -in localhost.csr -out localhost.crt



## EXTRACT INFO FROM CERTS...

echo "#### form bin/exmaples dir #### "  > cert1.txt
openssl x509 -in server_cert.der -text -noout >> cert1.txt

echo "#### CLIENT #### "  >> cert1.txt
openssl x509 -in client_cert.der -text -noout >> cert1.txt

echo "#### form tools/certs dir #### "  > cert2.txt
openssl x509 -in ~/GitHub/open62541/tools/certs/server_cert.der -text -noout >> cert2.txt

echo "#### CLIENT #### "  >> cert2.txt
openssl x509 -in ~/GitHub/open62541/tools/certs/client_cert.der -text -noout >> cert2.txt
meld cert1.txt cert2.txt









# -CA 
# -subj "/C=DE/L=Here/O=open62541/CN=open62541Server@localhost" \
# -CAkey  \


# -days 365 \

#echo "####" 
#openssl x509 \
# -req -in localhost.csr \
# -out localhost.crt \
# #-config ./localhost.cnf \
# -CA ./ca/intermediate/cacert_server.pem \
# -subj "/C=DE/L=Here/O=open62541/CN=open62541Server@localhost" \
# -CAkey ./ca/intermediate/private/intermediate-ca_server.key \
#-CAcreateserial \
# -days 365

