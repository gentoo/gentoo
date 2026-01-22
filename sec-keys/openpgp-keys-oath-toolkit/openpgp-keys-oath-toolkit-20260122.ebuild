# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'B1D2BD1375BECB784CF4F8C4D73CF638C53C06BE:jas:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used for sys-auth/oath-toolkit"
HOMEPAGE="https://oath-toolkit.codeberg.page/"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
