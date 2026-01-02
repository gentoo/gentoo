diff --git a/tests/test_index.py b/tests/test_index.py
index 95b1f05..984e241 100644
--- a/tests/test_index.py
+++ b/tests/test_index.py
@@ -60,11 +60,6 @@ class PackageIndexTestCase(DistlibTestCase):
     def setUpClass(cls):
         if cls.run_test_server:
             cls.server = None
-            server_script = os.path.join(HERE, 'pypi-server-standalone.py')
-            if not os.path.exists(server_script):
-                logger.debug('test server not available - some tests '
-                             'will be skipped.')
-                return
             pwdfn = os.path.join(HERE, 'passwords')
             if not os.path.exists(pwdfn):  # pragma: no cover
                 with open(pwdfn, 'w') as f:
@@ -76,7 +71,7 @@ class PackageIndexTestCase(DistlibTestCase):
             os.close(fd)
             cls.sink = sink = open(cls.sinkfile, 'w')
             cmd = [
-                sys.executable, 'pypi-server-standalone.py', '--interface', '127.0.0.1', '--port', TEST_SERVER_PORT,
+                'pypi-server', '--interface', '127.0.0.1', '--port', TEST_SERVER_PORT,
                 '-P', 'passwords', 'packages'
             ]
             cls.server = subprocess.Popen(cmd, stdout=sink, stderr=sink, cwd=HERE)
