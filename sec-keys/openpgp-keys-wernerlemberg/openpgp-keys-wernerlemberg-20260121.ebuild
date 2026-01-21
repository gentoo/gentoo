# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	E30674707856409FF1948010BE6C3AAC63AD8E3F:wl:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Werner Lemberg (wl)"
HOMEPAGE="https://freetype.org/download.html"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
