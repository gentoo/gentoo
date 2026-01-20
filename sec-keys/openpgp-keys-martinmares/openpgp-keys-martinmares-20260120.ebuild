# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	C466A56CADA981F4297D20C31F3D0761D9B65F0B:martin:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Martin Mareš"
HOMEPAGE="https://mj.ucw.cz/pgp.html"
SRC_URI="https://mj.ucw.cz/pgpkey.txt -> ${P}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
