# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic fortran-2 toolchain-funcs

MY_P1="CBFlib-${PV}"
#MY_P2="CBFlib_${PV}"
MY_P2="CBFlib_0.9.2"

DESCRIPTION="Library providing a simple mechanism for accessing CBF files and imgCIF files"
HOMEPAGE="http://www.bernstein-plus-sons.com/software/CBF/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P1}.tar.gz
	test? (
		mirror://sourceforge/${PN}/${MY_P2}_Data_Files_Input.tar.gz
		mirror://sourceforge/${PN}/${MY_P2}_Data_Files_Output.tar.gz
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

DEPEND="virtual/fortran"
RDEPEND="${DEPEND}"
#test? ( sys-process/time )"

S=${WORKDIR}/${MY_P1}

src_prepare(){
	rm -rf Py* drel* dRel* ply*
	epatch "${FILESDIR}"/${PV}-Makefile.patch
	cp Makefile_LINUX_gcc42 Makefile

	append-fflags -fno-range-check
	append-cflags -D_USE_XOPEN_EXTENDED -DCBF_DONT_USE_LONG_LONG

	sed \
		-e "s|^CC.*$|CC = $(tc-getCC)|" \
		-e "s|^C++.*$|C++ = $(tc-getCXX)|" \
		-e "s|C++|CXX|g" \
		-e "s|^CFLAGS.*$|CFLAGS = ${CFLAGS}|" \
		-e "s|^F90C.*$|F90C = $(tc-getFC)|" \
		-e "s|^F90FLAGS.*$|F90FLAGS = ${FFLAGS}|" \
		-e "s|^SOLDFLAGS.*$|SOLDFLAGS = -shared ${LDFLAGS}|g" \
		-e "s| /bin| ${EPREFIX}/bin|g" \
		-e "s|/usr|${EPREFIX}/usr|g" \
		-i Makefile || die
}

src_compile() {
	emake -j1 shared
}

src_test(){
	emake -j1 basic
}

src_install() {
	insinto /usr/include/${PN}
	doins include/*.h

	dolib.so solib/lib*

	dodoc README
	if use doc; then
		dohtml -r README.html html_graphics doc
	fi
}
