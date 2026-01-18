# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	343C2FF0FBEE5EC2EDBEF399F3599FF828C67298:niels:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Niels Möller (to sign GMP releases)"
HOMEPAGE="https://www.lysator.liu.se/~nisse/ https://gmplib.org/#DOWNLOAD"
SRC_URI="http://www.lysator.liu.se/~nisse/archive/distribution-key.gpg -> ${P}.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
