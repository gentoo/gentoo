# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	697E684D1668D6968428405CB78E893FA511976A:proftpd:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used for ProFTPD releases"
HOMEPAGE="http://www.proftpd.org/pgp.html"
SRC_URI="http://www.proftpd.org/pgp.html -> ${P}.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
