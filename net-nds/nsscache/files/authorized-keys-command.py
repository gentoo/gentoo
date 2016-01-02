#!/usr/bin/python
# vim: ts=4 sts=4 et:
# pylint: disable=invalid-name
"""
OpenSSH AuthorizedKeysCommand: NSSCache input
Copyright 2016 Gentoo Foundation
Distributed is distributed under the BSD license.

This script returns one or more authorized keys for use by SSH, by extracting
them from a local cache file /etc/sshkey.cache.

Two variants are supported, based on the existing nsscache code:
Format 1:
 username:key1
 username:key2
Format 2:
 username:['key1', 'key2']

Ensure this script is mentioned in the sshd_config like so:
AuthorizedKeysCommand /path/to/nsscache/authorized-keys-command.py
"""
from __future__ import print_function
from ast import literal_eval
from os.path import basename
import sys
import errno

SSHKEY_CACHE = '/etc/sshkey.cache'

if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Usage: %s %s" % (basename(sys.argv[0]), 'USERNAME'))

    try:
        with open(SSHKEY_CACHE, 'r') as f:
            for line in f:
                (username, key) = line.split(':', 1)
                if username != sys.argv[1]:
                    continue
                key = key.strip()
                if key.startswith("[") and key.endswith("]"):
                    # Python array
                    for i in literal_eval(key):
                        print(i.strip())
                else:
                    # Raw key
                    print(key)
    except IOError as err:
        if err.errno in [errno.EPERM, errno.ENOENT]:
            pass
        else:
            raise err
