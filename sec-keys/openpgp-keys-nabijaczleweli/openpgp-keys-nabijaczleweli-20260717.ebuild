# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'7D69474E84028C5CC0C44163BCFD0B018D2658F1:nabijaczleweli:github,manual,ubuntu,openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by наб (nabijaczleweli)"
HOMEPAGE="https://nabijaczleweli.xyz/"
SRC_URI+=" https://nabijaczleweli.xyz/pgp.txt -> ${P}-pgp.txt"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-macos"
