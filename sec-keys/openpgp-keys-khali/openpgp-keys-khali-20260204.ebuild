# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	7CA69F4460F1BDC41FD2C858A5526B9BB3CD4E6A:khali:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Jean Delvare (khali)"
HOMEPAGE="https://savannah.nongnu.org/users/khali"
SRC_URI="https://savannah.nongnu.org/people/viewgpg.php?user_id=12366 -> ${P}.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
