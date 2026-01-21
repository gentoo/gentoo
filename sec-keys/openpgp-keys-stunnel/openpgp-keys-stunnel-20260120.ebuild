# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	AC915EA30645D9D3D4DAE4FEB1048932DD3AAAA3:Michal.Trojnara:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by stunnel"
HOMEPAGE="https://www.stunnel.org/downloads.html"
SRC_URI="https://www.stunnel.org/pgp.asc -> ${P}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
