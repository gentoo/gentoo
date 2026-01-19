# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	08E2400FF7FE8FEDE3ACB52818147B073BAD2B07:olly:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Olly Betts"
HOMEPAGE="https://survex.com/~olly/"
SRC_URI="https://survex.com/~olly/gpg-public-key.txt -> ${P}-gpg-public-key.txt"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
