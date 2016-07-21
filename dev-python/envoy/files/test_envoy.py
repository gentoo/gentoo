import unittest
import envoy
import time

class SimpleTest(unittest.TestCase):

    def test_input(self):
        r = envoy.run("sed s/i/I/g", "Hi")
        self.assertEqual(r.std_out.rstrip(), "HI")
        self.assertEqual(r.status_code, 0)

    def test_pipe(self):
        r = envoy.run("echo -n 'hi'| tr [:lower:] [:upper:]")
        self.assertEqual(r.std_out, "HI")
        self.assertEqual(r.status_code, 0)

    def test_timeout(self):
        r = envoy.run('yes | head', timeout=1)
        self.assertEqual(r.std_out, 'y\ny\ny\ny\ny\ny\ny\ny\ny\ny\n')
        self.assertEqual(r.status_code, 0)

    # THIS TEST FAILS BECAUSE expand_args DOESN'T HANDLE QUOTES PROPERLY
    def test_quoted_args(self):
        sentinel = 'quoted_args' * 3
        r = envoy.run("python -c 'print \"%s\"'" % sentinel)
        self.assertEqual(r.std_out.rstrip(), sentinel)
        self.assertEqual(r.status_code, 0)

class ConnectedCommandTests(unittest.TestCase):

    def test_status_code_none(self):
        c = envoy.connect("sleep 5")
        self.assertEqual(c.status_code, None)

    def test_status_code_success(self):
        c = envoy.connect("sleep 1")
        time.sleep(2)
        self.assertEqual(c.status_code, 0)

    def test_status_code_failure(self):
        c = envoy.connect("sleeep 1")
        self.assertEqual(c.status_code, 127)

    def test_input(self):
        test_string = 'asdfQWER'
        r = envoy.connect("cat | tr [:lower:] [:upper:]")
        r.send(test_string)
        self.assertEqual(r.std_out, test_string.upper())
        self.assertEqual(r.status_code, 0)

if __name__ == "__main__":
    unittest.main()
