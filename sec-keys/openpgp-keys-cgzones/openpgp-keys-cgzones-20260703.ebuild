# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'8ECCDF12100AD84DA2EE7EBFC78CE737A3C3E28E:cgzones:github,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Christian Göttsche (cgzones)"
HOMEPAGE="https://github.com/cgzones"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
