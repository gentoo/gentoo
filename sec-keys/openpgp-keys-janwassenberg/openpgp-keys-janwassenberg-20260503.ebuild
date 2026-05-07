# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	1EE19F760E8995DEB6E7EAA8D37698ED2BD17D7F:jan:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Jan Wassenberg"
HOMEPAGE="https://github.com/jan-wassenberg"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
