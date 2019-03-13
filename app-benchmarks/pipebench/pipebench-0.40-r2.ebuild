# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Measures the speed of stdin/stdout communication"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=pipebench"
SRC_URI="ftp://ftp.habets.pp.se/pub/synscan/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86 ~x86-linux"
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-0.40-fix-build-system.patch )

src_configure() {
	append-cflags -Wall -w -pedantic
	tc-export CC
}
