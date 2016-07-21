# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Fast Base64 encoding/decoding routines"
HOMEPAGE="http://libb64.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.zip"

LICENSE="CC-PD"
# static library, so always rebuild
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

src_compile() {
	# override -O3, -Werror non-sense
	emake -C src CFLAGS="${CFLAGS} -I../include"
}

src_install() {
	dolib src/libb64.a
	insinto /usr/include
	doins -r include/b64
	dodoc AUTHORS BENCHMARKS CHANGELOG README
}
