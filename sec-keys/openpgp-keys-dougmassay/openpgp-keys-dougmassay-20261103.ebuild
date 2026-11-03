# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	B5A56206AB0FBC1A24EFAB8AA166D29A8FCDAC63:dougmassay:github,ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Doug Massay"
HOMEPAGE="https://github.com/dougmassay"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
