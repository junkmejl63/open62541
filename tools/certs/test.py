from Crypto.PublicKey import RSA
from Crypto.Signature import pkcs1_15
from Crypto.Hash import SHA256
from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization

# Load the certificate
with open("server_cert.pem", "rb") as cert_file:
    cert_data = cert_file.read()

# Load the certificate using the 'cryptography' library to parse it
cert = x509.load_pem_x509_certificate(cert_data, default_backend())

# Extract the public key from the certificate
public_key = cert.public_key()

# Export the public key in PEM format to be compatible with pycryptodome
pem_public_key = public_key.public_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PublicFormat.SubjectPublicKeyInfo
)

# Convert the PEM public key to an RSA key object using pycryptodome
pub_key = RSA.import_key(pem_public_key)

# Get the signature from the certificate
signature = cert.signature

# Get the TBS (To Be Signed) part of the certificate (all data except the signature)
tbs_certificate = cert.tbs_certificate_bytes

# Now, use the public key from the certificate to verify the signature
try:
    # Hash the TBS (To Be Signed) data with SHA-256
    hash_obj = SHA256.new(tbs_certificate)

    # Verify the signature using the public key
    pkcs1_15.new(pub_key).verify(hash_obj, signature)
    
    print("The certificate's signature is valid, and it is self-signed.")
except (ValueError, TypeError):
    print("The certificate's signature is invalid.")
