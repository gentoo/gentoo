import unittest

import whirlpool

from binascii import b2a_hex


results = {
    'empty'     : '19fa61d75522a4669b44e39c1d2e1726c530232130d407f89afee0964997f7a73e83be698b288febcf88e3e03c4f0757ea8964e59b63d93708b138cc42a66eb3',
    'tqbfjotld' : 'b97de512e91e3828b40d2b0fdce9ceb3c4a71f9bea8d88e75c4fa854df36725fd2b52eb6544edcacd6f8beddfea403cb55ae31f03ad62a5ef54e42ee82c3fb35',
    'tqbfjotle' : 'c27ba124205f72e6847f3e19834f925cc666d0974167af915bb462420ed40cc50900d85a1f923219d832357750492d5c143011a76988344c2635e69d06f2d38c',
    'tqbf'      : '317edc3c5172ea5987902aa9c4f1defedf4d5aa59209bdf7574cc6da0039852c24b8da70ecb07997ff83e86d32d2851215d3dcbd6bb9736bdef21c349d483e6d',
}


class TestWhirlpool(unittest.TestCase):

    def test_hash_empty(self):
        self.assertEqual(b2a_hex(whirlpool.hash('')), results['empty'])
    
    def test_hash_fox(self):
        self.assertEqual(
            b2a_hex(whirlpool.hash('The quick brown fox jumps over the lazy dog')),
            results['tqbfjotld'])
        self.assertEqual(
            b2a_hex(whirlpool.hash('The quick brown fox jumps over the lazy eog')),
            results['tqbfjotle'])

    def test_new_empty(self):
        wp = whirlpool.new()
        self.assertEqual(b2a_hex(wp.digest()), results['empty'])
        self.assertEqual(wp.hexdigest(), results['empty'])

    def test_new_fox(self):
        wp1 = whirlpool.new('The quick brown fox jumps over the lazy dog')
        self.assertEqual(b2a_hex(wp1.digest()), results['tqbfjotld'])
        self.assertEqual(wp1.hexdigest(), results['tqbfjotld'])

        wp2 = whirlpool.new('The quick brown fox jumps over the lazy eog')
        self.assertEqual(b2a_hex(wp2.digest()), results['tqbfjotle'])
        self.assertEqual(wp2.hexdigest(), results['tqbfjotle'])

    def test_update_copy(self):
        wp1 = whirlpool.new()
        wp2 = wp1.copy()
        wp1.update('The quick brown fox')
        wp3 = wp1.copy()

        self.assertEqual(b2a_hex(wp1.digest()), results['tqbf'])
        self.assertEqual(wp1.hexdigest(), results['tqbf'])

        self.assertEqual(b2a_hex(wp2.digest()), results['empty'])
        self.assertEqual(wp2.hexdigest(), results['empty'])

        self.assertEqual(b2a_hex(wp3.digest()), results['tqbf'])
        self.assertEqual(wp3.hexdigest(), results['tqbf'])

        wp1.update(' jumps over the lazy dog')

        self.assertEqual(b2a_hex(wp1.digest()), results['tqbfjotld'])
        self.assertEqual(wp1.hexdigest(), results['tqbfjotld'])

        self.assertEqual(b2a_hex(wp2.digest()), results['empty'])
        self.assertEqual(wp2.hexdigest(), results['empty'])

        self.assertEqual(b2a_hex(wp3.digest()), results['tqbf'])
        self.assertEqual(wp3.hexdigest(), results['tqbf'])

        wp3.update(' jumps over the lazy eog')

        self.assertEqual(b2a_hex(wp1.digest()), results['tqbfjotld'])
        self.assertEqual(wp1.hexdigest(), results['tqbfjotld'])

        self.assertEqual(b2a_hex(wp2.digest()), results['empty'])
        self.assertEqual(wp2.hexdigest(), results['empty'])

        self.assertEqual(b2a_hex(wp3.digest()), results['tqbfjotle'])
        self.assertEqual(wp3.hexdigest(), results['tqbfjotle'])

    def test_digest_size(self):
        wp = whirlpool.new()
        self.assertEqual(wp.digest_size, 64)
        with self.assertRaisesRegexp(AttributeError,
                                     'digest_size.*not writable'):
            wp.digest_size = 32
    
    def test_block_size(self):
        wp = whirlpool.new()
        self.assertEqual(wp.block_size, 64)
        with self.assertRaisesRegexp(AttributeError,
                                     'block_size.*not writable'):
            wp.block_size = 32


if __name__ == '__main__':
    unittest.main()
