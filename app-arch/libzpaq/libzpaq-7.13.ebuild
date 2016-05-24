# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

MY_P=zpaq${PV/./}
DESCRIPTION="Library to compress files in the ZPAQ format"
HOMEPAGE="http://mattmahoney.net/dc/zpaq.html"
SRC_URI="http://mattmahoney.net/dc/${MY_P}.zip"

LICENSE="zpaq"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +jit"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_compile() {
	use debug || append-cppflags -DNDEBUG
	use jit || append-cppflags -DNOJIT
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" libzpaq.so
}

src_test() {
	:
}

src_install() {
	# there's a common 'install' target for lib and cli
	dolib libzpaq.so*
	doheader libzpaq.h
}
