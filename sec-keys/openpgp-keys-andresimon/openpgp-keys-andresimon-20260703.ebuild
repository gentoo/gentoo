# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'B8C55574187F49180EDC763750FE0279D805A7C7:andresimon:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Andre Simo"
HOMEPAGE="http://andre-simon.de/zip/download.php#gpgsig"
SRC_URI+=" http://andre-simon.de/zip/andre_simon.pub -> ${P}-andre_simon.pub"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
