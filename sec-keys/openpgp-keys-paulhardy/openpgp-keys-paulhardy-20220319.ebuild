# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'95D2E9AB8740D8046387FD151A09227B1F435A33:paulhardy:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Paul Hardy"
HOMEPAGE="https://unifoundry.com/index.html"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
