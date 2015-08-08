# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic fortran-2 toolchain-funcs

MY_P1="CBFlib-${PV}"
#MY_P2="CBFlib_${PV}"
MY_P2="CBFlib_0.9.3"

DESCRIPTION="Library providing a simple mechanism for accessing CBF files and imgCIF files"
HOMEPAGE="http://www.bernstein-plus-sons.com/software/CBF/"
BASE_TEST_URI="http://arcib.dowling.edu/software/CBFlib/downloads/version_${PV}/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P1}.tar.gz"
#	test? (
#		mirror://sourceforge/${PN}/${MY_P2}_Data_Files_Input.tar.gz
#		mirror://sourceforge/${PN}/${MY_P2}_Data_Files_Output.tar.gz
#	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

S=${WORKDIR}/${MY_P1}

RDEPEND="sci-libs/hdf5:="
DEPEND="${RDEPEND}"

RESTRICT="test"

src_prepare(){
	rm -rf Py* drel* dRel* ply*
	epatch "${FILESDIR}"/${PV}-Makefile.patch
	cp Makefile_LINUX_gcc42 Makefile

	append-fflags -fno-range-check
	append-cflags -D_USE_XOPEN_EXTENDED -DCBF_DONT_USE_LONG_LONG

	sed \
		-e "s|^SOLDFLAGS.*$|SOLDFLAGS = -shared ${LDFLAGS}|g" \
		-i Makefile || die
	tc-export CC CXX AR RANLIB
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
	use doc && dohtml -r README.html html_graphics doc
}
