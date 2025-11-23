# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	28FF4B30A88D5523A7E2CBA20376A15C6FFC11CD:mjw:manual
	EC3CFE88F6CA0788774F5C1D1AA44BE649DE760A:mjw-old:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used to sign Valgrind releases"
HOMEPAGE="https://valgrind.org/downloads/"
# This is the same key as sec-keys/openpgp-keys-debugedit/sec-keys/openpgp-keys-bzip2
# but it's not guaranteed to always be the same, so let's not assume.
SRC_URI="https://gnu.wildebeest.org/~mark/gnupg-pub.txt -> ${P}-mjw.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
