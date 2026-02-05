# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	D62BDD168EFBE48BC60E8E234A6084B9C0D71F4A:tinc-devel:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by net-vpn/tinc"
HOMEPAGE="https://www.tinc-vpn.org/download/"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
