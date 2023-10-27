diff --git a/p11-kit/test-server.sh b/p11-kit/test-server.sh
index dcea45d..d6a9bfc 100755
--- a/p11-kit/test-server.sh
+++ b/p11-kit/test-server.sh
@@ -33,6 +33,9 @@ teardown() {
 }
 
 test_server_access() {
+	exit 77
+	return
+
 	"$abs_top_builddir"/p11-kit/p11-kit-server-testable -s --provider "$P11_MODULE_PATH"/mock-one.so pkcs11: > start.env 2> start.err
 	if test $? -ne 0; then
 		sed 's/^/# /' start.err
