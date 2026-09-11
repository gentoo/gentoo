# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'CBA23971357C2E6590D9EFD3EC8FEF3A7BFB4EDA:bradking:openpgp,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Brad King"
HOMEPAGE="https://cmake.org/download/"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
