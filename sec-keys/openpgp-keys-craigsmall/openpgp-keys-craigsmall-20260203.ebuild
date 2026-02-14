# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	5D2FB320B825D93904D205193938F96BDF50FEA5:craigsmall:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Craig Small"
HOMEPAGE="https://dropbear.xyz/about/"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
