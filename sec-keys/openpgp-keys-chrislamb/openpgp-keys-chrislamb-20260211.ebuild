# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	C2FE4BD271C139B86C533E461E953E27D4311E58:lamby:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Chris Lamb"
HOMEPAGE="https://chris-lamb.co.uk/"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
