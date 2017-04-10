import lz4
import sys


import unittest
import os

class TestLZ4(unittest.TestCase):

    def test_random(self):
      DATA = os.urandom(128 * 1024)  # Read 128kb
      self.assertEqual(DATA, lz4.loads(lz4.dumps(DATA)))

if __name__ == '__main__':
    unittest.main()

