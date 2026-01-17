# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'3AB057B7E78D945C8C5591FBD36F769BC11804F0:tytso:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Theodore Ts'o"
HOMEPAGE="https://thunk.org/tytso/"
SRC_URI="https://thunk.org/tytso/tytso-key.asc -> ${P}.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
