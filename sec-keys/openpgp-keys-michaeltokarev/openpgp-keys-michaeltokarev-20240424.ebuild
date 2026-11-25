# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'9D8BE14E3F2A9DD7919928F161AD3D98ECDF2C8E:mtokarev:openpgp,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the Michael Tokarev"
HOMEPAGE="https://www.corpit.ru/mjt/gpg.html"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
