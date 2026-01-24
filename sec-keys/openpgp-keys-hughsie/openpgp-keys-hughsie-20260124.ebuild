# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	163EB50119225DB3DF8F49EA17ACBA8DFA970E17:hughsie:github
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Richard Hughes (hughsie)"
HOMEPAGE="https://github.com/hughsie https://hughsie.com/"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
