# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic multilib toolchain-funcs versionator

MY_P="${PN}_$(replace_all_version_separators '_')"

DESCRIPTION="DUMA (Detect Unintended Memory Access) is a memory debugging library"
HOMEPAGE="http://duma.sourceforge.net/"

SRC_URI="mirror://sourceforge/duma/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}
	app-shells/bash"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	#DUMA_OPTIONS="-DDUMA_LIB_NO_LEAKDETECTION"
	DUMA_OPTIONS="-DDUMA_USE_FRAMENO"
	if [ -n "${DUMA_OPTIONS}" ]; then
	    ewarn ""
	    elog "Custom build options are ${DUMA_OPTIONS}."
	else
	    ewarn ""
	    elog "Custom build options are not set!"
	fi
	elog "See the package Makefile for for more options (also installed"
	elog "with package docs as Makefile.duma)."
	ewarn ""
}

src_unpack(){
	unpack ${A}
	cd "${S}"
	sed -i -e "s:(prefix)/lib:(prefix)/$(get_libdir):g" Makefile
	sed -i -e "s:share/doc/duma:share/doc/${P}:g" Makefile
}

src_compile(){
	replace-flags O? O0
	append-flags -Wall -Wextra -U_FORTIFY_SOURCE
	tc-export AR CC CXX LD RANLIB

	use amd64 && export DUMA_ALIGNMENT=16

	make CPPFLAGS="${DUMA_OPTIONS}" reconfig || die "make reconfig failed"
	emake CFLAGS="${CFLAGS}" CC=$(tc-getCC) || die "make failed"
}

src_test() {
	ewarn "Control-C now if you want to disable tests..."
	epause 5

	cd "${S}"
	use amd64 && export DUMA_ALIGNMENT=16
	make CFLAGS="${DUMA_OPTIONS} ${CFLAGS}" \
	    CC=$(tc-getCC) test || die "make test failed"

	elog ""
	ewarn "Check output above to verify all tests have passed.  Both"
	ewarn "static and dynamic confidence tests should say PASSED."
	elog ""
}

src_install(){
	# make install fails nicely here on the first file...
	make DESTDIR="${D}" install || die "make install failed"
	dodoc CHANGELOG TODO
	# All the good comments on duma build options are in the Makefile
	newdoc Makefile Makefile.duma

	if use examples; then
	    insinto /usr/share/doc/${P}/examples
	    doins example[1-6].cpp
	    doins example_makes/ex6/Makefile
	fi
}
