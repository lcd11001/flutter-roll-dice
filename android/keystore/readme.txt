Generate Keystores:
keytool -genkey -v -keystore rolldice.keystore -storepass 123456 -alias rolldice -keypass 123456 -keyalg RSA -keysize 2048 -validity 10000

keytool -genkey -v -keystore rolldice.jks -storepass b@byjumb0 -alias rolldice -keypass b@byjumb0 -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 

Warning: The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using 
"keytool -importkeystore -srckeystore rolldice.keystore -destkeystore rolldice_pkcs12.keystore -deststoretype pkcs12".

keytool -importkeystore -srckeystore rolldice.jks -destkeystore rolldice_pkcs12.jks -deststoretype pkcs12



Get Key Fingerprints:
keytool -list -v -keystore rolldice.keystore -storepass 123456 -alias rolldice -keypass 123456
keytool -list -v -keystore rolldice_pkcs12.keystore -storepass 123456 -alias rolldice -keypass 123456

keytool -list -v -keystore rolldice_pkcs12.jks -storepass b@byjumb0 -alias rolldice -keypass b@byjumb0

for Facebook hash
keytool -exportcert -alias rolldice -storepass 123456 -keystore rolldice.keystore | openssl sha1 -binary | openssl base64