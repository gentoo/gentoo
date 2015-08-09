# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Makeself archive extractor"
HOMEPAGE="http://www.freshports.org/archivers/unmakeself"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/libarchive[bzip2,zlib]"

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS=-larchive ${PN} || die "emake failed"
}

src_install() {
	dobin unmakeself || die "dobin failed"
}
