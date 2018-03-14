# About this Repo

This is nginx configs for abf.openmandriva.org

Where to get SSL certs?

git clone https://github.com/srvrco/getssl.git
getssl -c abf.openmandriva.org
getssl abf.openmandriva.org
cat abf.openmandriva.org.crt chain.crt > abf.openmandriva.org-chain.pem

.getssl/abf.openmandriva.org/getssl.cfg

```bash
CA="https://acme-v01.api.letsencrypt.org"
ACCOUNT_EMAIL="abf@openmandriva.org"
PRIVATE_KEY_ALG="rsa"
ACL=('/home/omv/letsencrypt/' '/home/omv/letsencrypt' '/home/omv/letsencrypt')
DOMAIN_CERT_LOCATION="/etc/ssl/abf.openmandriva.org.crt"
DOMAIN_KEY_LOCATION="/etc/ssl/abf.openmandriva.org.key"
CA_CERT_LOCATION="/etc/ssl/chain.crt"
DOMAIN_CHAIN_LOCATION="/home/omv/docker-nginx/full_chain.pem"
RENEW_ALLOW="30"
```

```bash
getssl -u -a

copying domain certificate to /etc/ssl/abf.openmandriva.org.crt
copying private key to /etc/ssl/abf.openmandriva.org.key
copying CA certificate to /etc/ssl/chain.crt
copying full pem to /home/omv/docker-nginx/full_chain.pem
```

copy in /home/omv/docker-nginx/

```bash
docker build --tag=openmandriva/nginx --file Dockerfile .
```
