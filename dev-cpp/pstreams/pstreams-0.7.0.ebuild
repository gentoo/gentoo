# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="C++ wrapper for the POSIX.2 functions popen(3) and pclose(3)"
HOMEPAGE="http://pstreams.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/${PN}-docs-${PV}.tar.gz )"

SLOT="0"
LICENSE="LGPL-3"
IUSE="doc"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_compile() {
	if use doc; then
		doxygen -u || die
		emake
	fi
}

src_test() {
	emake \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		check
}

src_install() {
	doheader pstream.h

	dodoc AUTHORS ChangeLog README

	use doc && dohtml -r "${WORKDIR}"/${PN}-docs-${PV}/*
}
