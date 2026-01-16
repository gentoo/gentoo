# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	342C4E3A39EA5F19909BE38AAE5D0DA3FD092353:lc-2024:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used to sign leancrypto releases"
HOMEPAGE="https://leancrypto.org/about/index.html"
SRC_URI="https://leancrypto.org/about/smuellerDD-2024.asc -> ${P}-2024.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
