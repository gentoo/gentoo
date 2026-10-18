# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	B1D2BD1375BECB784CF4F8C4D73CF638C53C06BE:josefsson:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the GNU SASL Library"
HOMEPAGE="https://www.gnu.org/software/gsasl/#downloading"
# Listed at https://www.gnu.org/software/libtasn1/
SRC_URI="
	https://josefsson.org/key-20190320.txt -> ${P}-josefsson-key-20190320.txt
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
