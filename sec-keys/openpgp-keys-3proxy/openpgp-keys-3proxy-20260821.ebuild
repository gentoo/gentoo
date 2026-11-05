# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'FC12214499FCC7BA1CFF6CDC0312384E3A73940B:vdubrovin:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the 3proxy developer"
HOMEPAGE="https://3proxy.org"
SRC_URI+=" https://3proxy.org/repo/3proxy-release-key.asc -> vdubrovin-${PV}.asc"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
