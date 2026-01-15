# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	47CC0331081B8BC6D0FD4DA08370665B57816A6A:mjw:manual
	EE8B11837F9C35A66A594B73C558590895ABF50C:mjw:manual
	28FF4B30A88D5523A7E2CBA20376A15C6FFC11CD:mjw:manual
	EC3CFE88F6CA0788774F5C1D1AA44BE649DE760A:mjw:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used to sign dwz releases"
HOMEPAGE="https://www.sourceware.org/dwz/"
# This is the same key as sec-keys/openpgp-keys-debugedit + sec-keys/openpgp-keys-bzip2
# but it's not guaranteed to always be the same, so let's not assume.
SRC_URI="https://www.klomp.org/mark/gnupg-pub.txt -> ${P}-mjw.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
