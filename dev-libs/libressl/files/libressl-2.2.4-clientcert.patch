untrusted comment: signature from openbsd 5.8 base secret key
RWQNNZXtC/MqP8u13/pPZfTpPeHhU93PG0DBihXvQ7lB0CvONLwoTfHr9f40s515bidPGcGLAH4xu+yz3skT6b3tKETEWZw8BgA=

OpenBSD 5.8 errata 9, Dec 3, 2015:

CVE-2015-3194 - NULL pointer dereference in client certificate validation

Apply by doing:
    signify -Vep /etc/signify/openbsd-58-base.pub -x 009_clientcert.patch.sig \
        -m - | (cd /usr/src && patch -p0)

And then rebuild and install libcrypto:
    cd /usr/src/lib/libcrypto
    make obj
    make depend
    make
    make install

Index: lib/libssl/src/crypto/rsa/rsa_ameth.c
===================================================================
RCS file: /cvs/src/lib/libssl/src/crypto/rsa/rsa_ameth.c,v
retrieving revision 1.14
retrieving revision 1.14.6.1
diff -u -p -u -p -r1.14 -r1.14.6.1
--- lib/libssl/src/crypto/rsa/rsa_ameth.c	11 Feb 2015 04:05:14 -0000	1.14
+++ lib/libssl/src/crypto/rsa/rsa_ameth.c	4 Dec 2015 04:13:43 -0000	1.14.6.1
@@ -298,7 +298,7 @@ rsa_pss_decode(const X509_ALGOR *alg, X5
 	if (pss->maskGenAlgorithm) {
 		ASN1_TYPE *param = pss->maskGenAlgorithm->parameter;
 		if (OBJ_obj2nid(pss->maskGenAlgorithm->algorithm) == NID_mgf1 &&
-		    param->type == V_ASN1_SEQUENCE) {
+		    param && param->type == V_ASN1_SEQUENCE) {
 			p = param->value.sequence->data;
 			plen = param->value.sequence->length;
 			*pmaskHash = d2i_X509_ALGOR(NULL, &p, plen);
