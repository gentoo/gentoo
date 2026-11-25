# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	A785ED2755955D9E93EA59F6597F97EA9AD45549:roy:openpgp,ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Roy Marples"
HOMEPAGE="https://roy.marples.name/"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
