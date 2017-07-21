# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit flag-o-matic

DESCRIPTION="A GiNaC-based library for symbolic expansion of certain transcendental functions"
HOMEPAGE="http://wwwthep.physik.uni-mainz.de/~stefanw/nestedsums/"
IUSE="doc"
SRC_URI="http://wwwthep.physik.uni-mainz.de/~stefanw/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND=">=sci-mathematics/ginac-1.7"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	append-cxxflags -std=c++11
	default
}

src_compile() {
	default

	if use doc; then
		doxygen Doxyfile || die "generating documentation failed"
	fi
}

src_test() {
	emake check
}

src_install() {
	emake DESTDIR="${D}" install
	rm -f "${D}"usr/lib/*.la
	dodoc AUTHORS ChangeLog

	if use doc; then
		dohtml reference/html/*
	fi
}
