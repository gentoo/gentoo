# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'7C0135FB088AAF6C66C650B9BB5869F064EA74AB:chet:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Chet Ramey"
HOMEPAGE="https://tiswww.case.edu/php/chet/"
SRC_URI+=" https://tiswww.case.edu/php/chet/gpgkey.asc -> ${P}-gpgkey.asc"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
