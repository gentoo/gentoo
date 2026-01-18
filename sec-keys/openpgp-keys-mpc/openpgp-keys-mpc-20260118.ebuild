# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	AD17A21EF8AED8F1CC02DBD9F7D5C9BF765C61E3:enge:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Andreas Enge (to sign MPC releases)"
HOMEPAGE="https://www.multiprecision.org/mpc/download.html"
SRC_URI="https://www.multiprecision.org/downloads/enge.gpg -> ${P}-enge.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
