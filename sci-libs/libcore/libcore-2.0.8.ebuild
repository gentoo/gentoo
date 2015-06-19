# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libcore/libcore-2.0.8.ebuild,v 1.1 2009/08/13 00:28:42 bicatali Exp $

EAPI=2
inherit eutils toolchain-funcs versionator

MYPN=core
DOCPV="$(get_version_component_range 1-2)"

DESCRIPTION="Robust numerical and geometric computation library"
HOMEPAGE="http://www.cs.nyu.edu/exact/core_pages/"
SRC_URI="http://cs.nyu.edu/exact/core/download/${MYPN}/${MYPN}-${PV}.tgz
	doc? ( http://cs.nyu.edu/exact/core/download/${MYPN}/${MYPN}-${DOCPV}.doc.tgz )"

LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-libs/mpfr
	dev-libs/gmp
	doc? ( app-doc/doxygen[latex] )"

S="${WORKDIR}/${MYPN}-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefiles.patch
	sed -i \
		-e "s/-O2/${CXXFLAGS}/g" \
		-e "s/-shared/-shared ${LDFLAGS}/g" \
		Make.config || die
	sed -i -e 's/-lgmp/-lgmp -lgmpxx/g' progs/Make.options || die
	# missing input file in gaussian test and buggy test in tutorial
	sed -i -e '/gaussian/d' -e '/tutorial/d' progs/Makefile || die
}

src_compile(){
	emake VAR= LINKAGE=shared corelib corex USE_GMPXX=1 || die "emake shared failed"
	rm -f src/*.o ext/*.o
	emake VAR="" corelib corex USE_GMPXX=1 || die "emake static failed"
	if use doc; then
		cd "${S}/doc"
		export VARTEXFONTS="${T}/fonts"
		emake -j1 all || die "doc creation failed"
		emake -j1 -C doxy/latex pdf || die "pdf doc creation failed"
	fi
}

src_test() {
	LD_LIBRARY_PATH="${S}/lib" emake VAR="" test || die "emake test failed"
}

src_install(){
	dolib lib/*.a lib/*.so* || die "Unable to find libraries"
	for i in $(find "${D}/usr/$(get_libdir)" -name "*so" | sed "s:${D}::g"); do
		dosym $i.2.0.0 $i.2 && dosym $i.2 $i || die "Unable to sym $i"
	done

	dodir /usr/include || die "Unable to create include dir"
	cp -r ./inc/* "${D}/usr/include/" || die "Unable to copy headers"

	dodoc FAQs README
	if use doc; then
		dodoc doc/*.txt
		insinto /usr/share/doc/${PF}
		doins doc/papers/* doc/tutorial/tutorial.pdf || die
		doins -r doc/doxy/html doc/doxy/latex/*pdf || die
	fi
}
