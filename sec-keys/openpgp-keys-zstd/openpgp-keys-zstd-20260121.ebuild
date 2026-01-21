# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	4EF4AC63455FC9F4545D9B7DEF8FE99528B52FFD:zstd:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by app-arch/zstd"
HOMEPAGE="https://facebook.github.io/zstd/"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
