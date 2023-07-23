#!/usr/bin/env python
#
# Distributed under the terms of the GNU General Public License v2
#
# Takes as input:
# 1. authority keys as gentoo-auth.asc (sec-keys/openpgp-keys-gentoo-auth);
# 2. a downloaded, unverified bundle of active developers from qa-reports.gentoo.org (https://qa-reports.gentoo.org/output/active-devs.gpg);
#    but this must be converted to ASCII first(!), and
# 3. an output file (armored).
#
# Outputs armored keyring with all expired keys dropped and all keys without
# a signature from the L2 developer key dropped.
#
# Usage: python keyring-mangler.py <gentoo-auth.asc> <active-devs.gpg> <output for armored keys.asc>
from xml.dom import ValidationErr

import gnupg
import os
import sys

AUTHORITY_KEYS = [
    # Gentoo Authority Key L1
    "ABD00913019D6354BA1D9A132839FE0D796198B1",
    # Gentoo Authority Key L2 for Services
    "18F703D702B1B9591373148C55D3238EC050396E",
    # Gentoo Authority Key L2 for Developers
    "2C13823B8237310FA213034930D132FF0FF50EEB",
]

L2_DEVELOPER_KEY = "30D132FF0FF50EEB"

# logging.basicConfig(level=os.environ.get("LOGLEVEL", "DEBUG"))

gentoo_auth = sys.argv[1]
active_devs = sys.argv[2]
armored_output = sys.argv[3]

gpg = gnupg.GPG(verbose=False, gnupghome=os.environ["GNUPGHOME"])
gpg.encoding = "utf-8"

with open(gentoo_auth, "r", encoding="utf8") as keyring:
    keys = keyring.read()
    gpg.import_keys(keys)

gpg.trust_keys([AUTHORITY_KEYS[0]], "TRUST_ULTIMATE")

with open(active_devs, "r", encoding="utf8") as keyring:
    keys = keyring.read()
    gpg.import_keys(keys)

# print(keys)
# print(gpg.list_keys)

good_keys = []

# TODO: Use new 'problems' key from python-gnupg-0.5.1?
for key in gpg.list_keys(sigs=True):
    print(f"Checking key={key['keyid']}, uids={key['uids']}")

    # pprint.pprint(key)

    if key["fingerprint"] in AUTHORITY_KEYS:
        # Just add this in.
        good_keys.append(key["fingerprint"])
        continue

    # https://security.stackexchange.com/questions/41208/what-is-the-exact-meaning-of-this-gpg-output-regarding-trust
    if key["trust"] == "e":
        # If it's expired, drop the key, as we can't easily then
        # verify it because of gpg limitations.
        print(
            f"Dropping expired {key['keyid']=}, {key['uids']=} (because this prevents validation)"
        )
        continue

    if key["trust"] == "-":
        print(f"Dropping {key['keyid']=}, {key['uids']=} because no trust calculated")
        continue

    if key["trust"] != "f":
        print(
            f"Dropping {key['keyid']=}, {key['uids']=} because not calculated as fully trusted"
        )
        continue

    # As a sanity check, make sure each key has a signature from
    # the L2 developer signing key.
    got_l2_signature = any(sig[0] == "30D132FF0FF50EEB" for sig in key["sigs"])
    if not got_l2_signature:
        raise ValidationErr(f"{key['uids']=} lacks a signature from L2 key!")

    good_keys.append(key["fingerprint"])

with open(armored_output, "w", encoding="utf8") as keyring:
    keyring.write(gpg.export_keys(good_keys))
