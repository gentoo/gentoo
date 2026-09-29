# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'8773D61D68E30E072B10DC1AD19E9C7D71266DCE:branden:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by GNU roff"
HOMEPAGE="https://www.gnu.org/software/groff"
SRC_URI+=" https://savannah.gnu.org/people/viewgpg.php?user_id=108747 -> ${P}-branden.asc"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
