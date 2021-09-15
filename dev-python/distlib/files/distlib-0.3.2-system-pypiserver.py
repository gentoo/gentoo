diff -dupr a/tests/test_index.py b/tests/test_index.py
--- a/tests/test_index.py	2021-05-29 17:42:08.015558305 +0200
+++ b/tests/test_index.py	2021-05-29 17:42:56.949966576 +0200
@@ -57,11 +57,6 @@ class PackageIndexTestCase(DistlibTestCa
     def setUpClass(cls):
         if cls.run_test_server:
             cls.server = None
-            server_script = os.path.join(HERE, 'pypi-server-standalone.py')
-            if not os.path.exists(server_script):
-                logger.debug('test server not available - some tests '
-                             'will be skipped.')
-                return
             pwdfn = os.path.join(HERE, 'passwords')
             if not os.path.exists(pwdfn):   # pragma: no cover
                 with open(pwdfn, 'w') as f:
@@ -72,7 +67,7 @@ class PackageIndexTestCase(DistlibTestCa
             fd, cls.sinkfile = tempfile.mkstemp(suffix='.log', prefix='distlib-pypi-')
             os.close(fd)
             cls.sink = sink = open(cls.sinkfile, 'w')
-            cmd = [sys.executable, 'pypi-server-standalone.py',
+            cmd = ['pypi-server',
                    '--interface', '127.0.0.1', '--port', TEST_SERVER_PORT,
                    '-P', 'passwords', 'packages']
             cls.server = subprocess.Popen(cmd, stdout=sink, stderr=sink,
