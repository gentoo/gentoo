# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	1F166A5742ABB9E0249A8D30E089DEF1D9C15D0D:tcpdump:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign tcpdump releases"
HOMEPAGE="https://www.tcpdump.org/index.html#latest-releases"
SRC_URI="https://www.tcpdump.org/release/signing-key-RSA-E089DEF1D9C15D0D.asc -> ${P}.gpg"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
