# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'017D74E27F5856963801781DF663943E08D8092A:ldbraun:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Lars-Dominik Braun"
HOMEPAGE="https://codeberg.org/purplesym/"
SRC_URI+=" https://codeberg.org/purplesym.gpg -> ${P}.asc"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
