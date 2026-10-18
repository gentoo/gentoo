# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'6C222EA6B2BD216AA406516AC868F0B6DE38409D:kamila:manual,openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Kamila Szewczyk"
HOMEPAGE="https://iczelia.net/about/"
SRC_URI+=" https://iczelia.net/pub.pgp -> ${P}.asc"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
