# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'942B9075ACCA04E9037C73FED31B5563DAC1D4FA:aspiers:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Adam Spiers"
HOMEPAGE="https://savannah.gnu.org/users/aspiers"
SRC_URI="https://savannah.gnu.org/people/viewgpg.php?user_id=85959 -> ${P}.asc"

KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
