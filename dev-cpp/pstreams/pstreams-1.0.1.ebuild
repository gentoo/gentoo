# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="C++ wrapper for the POSIX.2 functions popen(3) and pclose(3)"
HOMEPAGE="http://pstreams.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/${PN}-docs-${PV}.tar.gz )"

LICENSE="LGPL-3"
SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~x86"

BDEPEND="doc? ( app-doc/doxygen )"

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

	if use doc ; then
		docinto html
		dodoc -r "${WORKDIR}"/${PN}-docs-${PV}/*
	fi
}
