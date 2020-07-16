From 30b1b46cb02cef9cb0317a3500fd1497e594a797 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20G=C3=B3rny?= <mgorny@gentoo.org>
Date: Wed, 8 Jul 2020 09:24:42 +0200
Subject: [PATCH] Use system pypiserver

---
 tests/test_index.py | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/tests/test_index.py b/tests/test_index.py
index bc24367..623b027 100644
--- a/tests/test_index.py
+++ b/tests/test_index.py
@@ -52,11 +52,6 @@ class PackageIndexTestCase(unittest.TestCase):
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
@@ -65,7 +60,7 @@ class PackageIndexTestCase(unittest.TestCase):
             if not os.path.isdir(pkgdir):   # pragma: no cover
                 os.mkdir(pkgdir)
             cls.sink = sink = open(os.devnull, 'w')
-            cmd = [sys.executable, 'pypi-server-standalone.py',
+            cmd = [sys.executable, '-m', 'pypiserver',
                    '-P', 'passwords', 'packages']
             cls.server = subprocess.Popen(cmd, stdout=sink, stderr=sink,
                                           cwd=HERE)
-- 
2.27.0

