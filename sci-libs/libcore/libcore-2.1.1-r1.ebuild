# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libcore/libcore-2.1.1-r1.ebuild,v 1.2 2012/08/03 19:34:54 bicatali Exp $

EAPI=4
inherit eutils toolchain-funcs versionator

MYPN=core
DOCPV="$(get_version_component_range 1-2)"

DESCRIPTION="Robust numerical and geometric computation library"
HOMEPAGE="http://www.cs.nyu.edu/exact/core_pages/"
SRC_URI="http://cs.nyu.edu/exact/core/download/${MYPN}/${MYPN}-${PV}.tgz
	doc? ( http://cs.nyu.edu/exact/core/download/${MYPN}/${MYPN}-${DOCPV}.doc.tgz )"

LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-libs/mpfr
	dev-libs/gmp
	doc? ( app-doc/doxygen[latex] )"

S="${WORKDIR}/${MYPN}-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-makefiles.patch
	sed -i \
		-e "s/-O2/${CXXFLAGS}/g" \
		-e "s/-shared/-shared ${LDFLAGS}/g" \
		Make.config || die
	sed -i -e 's/-lgmp/-lgmp -lgmpxx/g' progs/Make.options || die
	# missing input file in gaussian test and buggy test in tutorial
	sed -i -e '/gaussian/d' -e '/tutorial/d' progs/Makefile || die
}

src_compile(){
	emake VAR= LINKAGE=shared corelib corex USE_GMPXX=1
	rm -f src/*.o ext/*.o
	use static-libs && emake VAR="" corelib corex USE_GMPXX=1
	if use doc; then
		cd "${S}/doc"
		export VARTEXFONTS="${T}/fonts"
		emake -j1 all
		emake -j1 -C doxy/latex pdf
	fi
}

src_test() {
	LD_LIBRARY_PATH="${S}/lib" emake \
		VAR= GMP_PREFIX= MPFR_PREFIX= test
}

src_install(){
	dolib.so lib/*.so*
	for i in $(find "${ED}/usr/$(get_libdir)" -name "*so" | sed "s:${ED}::g"); do
		dosym $i.2 $i
	done
	use static-libs && dolib.a lib/*.a

	insinto /usr/include
	doins inc/CORE.h
	insinto /usr/include/CORE
	doins inc/CORE/*.h

	dodoc FAQs README
	if use doc; then
		dodoc doc/*.txt
		dodoc doc/tutorial/tutorial.pdf doc/doxy/latex/*pdf
		dohtml -r doc/doxy/html/*
	fi
}
