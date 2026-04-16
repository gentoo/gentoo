# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	7C4AFD61D8AAE7570796A5172209D6902F969C95:marcusmeissner:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Marcus Meissner"
HOMEPAGE="https://github.com/msmeissn"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86"
