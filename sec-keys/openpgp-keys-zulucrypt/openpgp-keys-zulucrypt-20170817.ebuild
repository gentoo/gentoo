# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'E3AF84691424AD00E099003502FC64E8DEBF43A8:banyikwafb:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the zuluCrypt developer"
HOMEPAGE="https://mhogomchungu.github.io/zuluCrypt/"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
