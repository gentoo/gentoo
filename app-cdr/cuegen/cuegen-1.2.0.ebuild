# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="CUEgen is a FLAC-compatible cuesheet generator for Linux"
HOMEPAGE="http://www.cs.man.ac.uk/~slavinp/cuegen.html"
SRC_URI="http://www.cs.man.ac.uk/~slavinp/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-1.2.0-fix-build-system.patch )

src_configure() {
	append-cflags -W -Wall -Wstrict-prototypes -Wmissing-prototypes
	tc-export CC
}

src_install() {
	dobin cuegen
	einstalldocs
}
