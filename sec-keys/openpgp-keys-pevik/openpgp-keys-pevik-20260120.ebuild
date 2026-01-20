# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	2016FEA4858B1C36B32E833AC0DEC2EE72F33A5F:pevik:github
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Petr Vorel (pevik)"
HOMEPAGE="https://github.com/pevik"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
