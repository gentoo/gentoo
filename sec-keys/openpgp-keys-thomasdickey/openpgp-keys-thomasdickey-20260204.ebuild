# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	19882D92DDA4C400C22C0D56CC2AF4472167BE03:dickey:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Thomas Dickey"
HOMEPAGE="https://invisible-island.net/public/public.html"
SRC_URI="https://invisible-island.net/public/dickey@invisible-island.net-rsa3072.asc -> ${P}-dickey@invisible-island.net-rsa3072.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
