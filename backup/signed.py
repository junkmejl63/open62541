#!/usr/bin/env python3
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright 2019 (c) Kalycito Infotech Private Limited
# Modified 2025 (c) Construction Future Lab

import netifaces
import sys
import os
import socket
import argparse
import subprocess

parser = argparse.ArgumentParser()

parser.add_argument('outdir',
                    type=str,
                    nargs='?',
                    default=os.getcwd(),
                    metavar='<OutputDirectory>')

parser.add_argument('-u', '--uri',
                    metavar="<ApplicationUri>",
                    type=str,
                    default="",
                    dest="uri")

parser.add_argument('-k', '--keysize',
                    metavar="<KeySize>",
                    type=int,
                    dest="keysize")

parser.add_argument('-c', '--certificatename',
                     metavar="<CertificateName>",
                     type=str,
                     default="",
                     dest="certificatename")

parser.add_argument('-S', '--signing_cert',
                    metavar="<signing_cert>",
                    type=str,
                    default="",
                    dest="signing_cert"  )

parser.add_argument('-K', '--signing_key',
                    metavar="<signing_key>",
                    type=str,
                    default="",
                    dest="signing_key"  )

parser.add_argument('-n', '--commonname',
                    metavar="<commonname>",
                    type=str,
                    default="",
                    dest="commonname"  )



args = parser.parse_args()

if not os.path.exists(args.outdir):
    sys.exit('ERROR: Directory %s was not found!' % args.outdir)

keysize = 2048

if args.keysize:
    keysize = args.keysize

if args.uri == "":
    args.uri = "urn:open62541.unconfigured.application"
    print("No ApplicationUri given for the certificate. Setting to %s" % args.uri)
os.environ['URI1'] = args.uri

if args.certificatename == "":
    certificatename = "server"
    print("No Certificate name provided. Setting to %s" % certificatename)

if args.certificatename:
     certificatename = args.certificatename

signing_key=args.signing_key
if args.signing_key == "":
    signing_key = "./ca/intermediate/private/intermediate-ca_server.key"
    print("No key provided. Setting to \"%s\"" % signing_key)

signing_cert=args.signing_cert
if args.signing_cert == "":
    signing_cert = "./ca/intermediate/cacert_server.pem"
    print("No cert provided. Setting to \"%s\"" % signing_cert)


subject=args.subject
if args.subject == "":
    subject = "/C=DE/L=Here/O=open62541/CN=open62541Server@localhost"
    print("No CN provided. Setting to \"%s\"" % subject)
print("sub_fields:", subject)


certsdir = os.path.dirname(os.path.abspath(__file__))

# Function return TRUE (1) when an IP address is associated with the
# given interface
def is_interface_up(interface):
    addr = netifaces.ifaddresses(interface)
    return netifaces.AF_INET in addr

# Initialize looping variables
interfaceNum = 0
iteratorValue = 0

# Read the number of interfaces available
numberOfInterfaces = int(format(len(netifaces.interfaces())))

# Traverse through the available network interfaces and store the
# corresponding IP addresses of the network interface in a variable
for interfaceNum in range(0, numberOfInterfaces):
    # Function call which returns whether the given
    # interface is up or not
    check = is_interface_up(netifaces.interfaces()[interfaceNum])

    # Check if the interface is up and not the loopback one
    # If yes set the IP Address for the environmental variables
    if check != 0 and netifaces.interfaces()[interfaceNum] != 'lo':
        if iteratorValue == 0:
            os.environ['IPADDRESS1'] = netifaces.ifaddresses(netifaces.interfaces()[interfaceNum])[netifaces.AF_INET][0]['addr']
        if iteratorValue == 1:
            os.environ['IPADDRESS2'] = netifaces.ifaddresses(netifaces.interfaces()[interfaceNum])[netifaces.AF_INET][0]['addr']
        iteratorValue = iteratorValue + 1
        if iteratorValue == 2:
            break

# If there is only one interface available then set the second
# IP address as loopback IP
if iteratorValue < 2:
    os.environ['IPADDRESS2'] = "127.0.0.1"

os.environ['HOSTNAME'] = socket.gethostname()
openssl_conf = os.path.join(certsdir, "localhost.cnf")

os.chdir(os.path.abspath(args.outdir))

# Use subprocess instead of os.system for better error handling
try:


    #subprocess.run([ 
    #   "openssl", "genpkey", "-algorithm", "RSA", "-out", "localhost.key",
    #   "-pkeyopt", "rsa_keygen_bits:2048"
    #], check=True)

    #subprocess.run([ 
    #    "openssl", "req", "-new", "-key", "localhost.key", 
    #    "-out", "localhost.csr", 
    #], check=True)
    #    "-subj", "/C=DE/L=Here/O=open62541/CN=open62541Server@localhost",  # Subject info        
    #    "-days", "365",  # Valid for 365 days
    #    "-config", "localhost.cnf"
    # openssl req -new -key private.key -out request.csr


    #    subprocess.run([ 
    #        "openssl", "req",
    #       "-new", "-nodes", "-sha256",  # Create a new CSR
    #        "-newkey", f"rsa:{keysize}",  # Generate RSA key of size keysize
    #        "-keyout", "localhost.key",  # Private key for the server
    #        "-days", "365",  # Valid for 365 days
    #       "-subj", "/C=DE/L=Here/O=open62541/CN=open62541Server@localhost",  # Subject info
    #       "-out", "localhost.csr"  # Output CSR (Certificate Signing Request)
    #  #  ], check=True)
    #   "-config", openssl_conf,  # Configuration file
    
    print(".........1............")
    
    # Now sign the CSR with the root or intermediate CA's private key
    
    # Generate key
    subprocess.run([
        "openssl", "req",
        "-new", "-nodes", "-sha256",
        "-newkey", "rsa:2048,",
        "-keyout", "localhost.key",
        "-config", "./test.conf",
        "-subj", subject,
        "-out", "localhost.csr"
    ], check=True)

    subprocess.run([
        "openssl", "ca", "-batch",
        "-keyfile", signing_key,
        "-cert", signing_cert,
        "-config", "./test.conf",
        "-in", "localhost.csr", "-out", "localhost.crt",
    ], check=True)

    
    
    print("..........2...........")
    # Conert to der...
    
    subprocess.run([
        "openssl", "x509",
        "-in", "localhost.crt",
        "-outform", "der",
        "-out", f"{certificatename}_cert.der"
    ], check=True)
    print("..........3...........")
    
    subprocess.run([
        "openssl", "rsa",
        "-inform", "PEM",
        "-in", "localhost.key",
        "-outform", "DER",
        "-out", f"{certificatename}_key.der"
    ], check=True)
    
except subprocess.CalledProcessError as e:
    sys.exit(f'ERROR: OpenSSL command failed: {e}')

os.remove("localhost.key")
os.remove("localhost.crt")

print("Certificates generated in " + args.outdir)
