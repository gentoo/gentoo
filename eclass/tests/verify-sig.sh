#!/bin/bash
# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

inherit verify-sig

TMP=$(mktemp -d)
trap 'rm -rf "${TMP}"' EXIT
cd "${TMP}" || die
> empty || die
> fail || die
echo "The quick brown fox jumps over the lazy dog." > text || die

testit() {
	local expect=${1}
	shift

	tbegin "${*@Q}"
	( "${@}" )
	[[ ${?} -eq ${expect} ]]
	tend "${?}"
}

test_verify_unsigned_checksums() {
	local format=${1}

	testit 0 verify-sig_verify_unsigned_checksums checksums.txt "${format}" empty
	testit 0 verify-sig_verify_unsigned_checksums checksums.txt "${format}" "empty text"
	testit 1 verify-sig_verify_unsigned_checksums checksums.txt "${format}" other
	testit 1 verify-sig_verify_unsigned_checksums checksums.txt "${format}" "empty other"
	testit 1 verify-sig_verify_unsigned_checksums checksums.txt "${format}" fail
	testit 1 verify-sig_verify_unsigned_checksums checksums.txt "${format}" "empty fail"
}

einfo "Testing coreutils format."
eindent

cat > checksums.txt <<-EOF || die
	# some junk to test junk protection
	b47cc0f104b62d4c7c30bcd68fd8e67613e287dc4ad8c310ef10cbadea9c4380 empty junk line
	b47cc0f104b62d4c7c30bcd68gd8e67613e287dc4ad8c310ef10cbadea9c4380 empty

	# sha1sums
	da39a3ee5e6b4b0d3255bfef95601890afd80709 empty
	9c04cd6372077e9b11f70ca111c9807dc7137e4b	text
	9c04cd6372077e9b11f70ca111c9807dc7137e4b fail

	# sha256sums
	e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 empty
	b47cc0f104b62d4c7c30bcd68fd8e67613e287dc4ad8c310ef10cbadea9c4380	text
	b47cc0f104b62d4c7c30bcd68fd8e67613e287dc4ad8c310ef10cbadea9c4380 fail

	# sha512sums
	cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e empty
	020da0f4d8a4c8bfbc98274027740061d7df52ee07091ed6595a083e0f45327bbe59424312d86f218b74ed2e25507abaf5c7a5fcf4cafcf9538b705808fd55ec	text
	020da0f4d8a4c8bfbc98274027740061d7df52ee07091ed6595a083e0f45327bbe59424312d86f218b74ed2e25507abaf5c7a5fcf4cafcf9538b705808fd55ec fail

	# duplicate checksum
	e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 empty
EOF

test_verify_unsigned_checksums sha256
eoutdent

einfo "Testing openssl-dgst format."
eindent

> "annoying ( filename )= yes ).txt" || die

cat > checksums.txt <<-EOF || die
	junk text that ought to be ignored

	SHA1(empty)=da39a3ee5e6b4b0d3255bfef95601890afd80709
	SHA1(text)= 9c04cd6372077e9b11f70ca111c9807dc7137e4b
	SHA1(fail)=9c04cd6372077e9b11f70ca111c9807dc7137e4b

	SHA256(empty)=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
	SHA256(text)= b47cc0f104b62d4c7c30bcd68fd8e67613e287dc4ad8c310ef10cbadea9c4380
	SHA256(fail)=b47cc0f104b62d4c7c30bcd68fd8e67613e287dc4ad8c310ef10cbadea9c4380

	SHA256(annoying ( filename )= yes )= e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

	SHA512(empty)=cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
	SHA512(text)= 020da0f4d8a4c8bfbc98274027740061d7df52ee07091ed6595a083e0f45327bbe59424312d86f218b74ed2e25507abaf5c7a5fcf4cafcf9538b705808fd55ec
	SHA512(fail)=020da0f4d8a4c8bfbc98274027740061d7df52ee07091ed6595a083e0f45327bbe59424312d86f218b74ed2e25507abaf5c7a5fcf4cafcf9538b705808fd55ec
EOF

test_verify_unsigned_checksums openssl-dgst
eoutdent

texit
