# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="3"
DESCRIPTION="A GiNaC-based library for symbolic expansion of certain transcendental functions"
HOMEPAGE="http://wwwthep.physik.uni-mainz.de/~stefanw/nestedsums/"
IUSE="doc"
SRC_URI="http://wwwthep.physik.uni-mainz.de/~stefanw/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
RDEPEND=">=sci-mathematics/ginac-1.5"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_compile() {
	emake || die "emake failed"

	if use doc; then
		doxygen Doxyfile || die "generating documentation failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	rm -f "${D}"usr/lib/*.la
	dodoc AUTHORS ChangeLog

	if use doc; then
		dohtml reference/html/* || die "installing documentation failed"
	fi
}
