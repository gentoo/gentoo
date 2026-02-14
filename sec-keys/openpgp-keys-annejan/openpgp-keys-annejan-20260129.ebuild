# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	DF7FEF8DFBA721E320B18F5615B63ADCA0034B9E:annejan:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Anne Jan Brouwer (annejan)"
HOMEPAGE="https://annejan.com/"
SRC_URI="https://annejan.com/key -> ${P}.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
