# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"B1FA7D81EEB8E66399178B9733EBBFC47B3DD87D:rouault:github,openpgp,ubuntu"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Even Rouault"
HOMEPAGE="https://github.com/rouault"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
