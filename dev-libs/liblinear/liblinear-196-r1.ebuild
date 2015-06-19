# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liblinear/liblinear-196-r1.ebuild,v 1.12 2015/02/28 13:28:11 ago Exp $

EAPI=5
inherit multilib toolchain-funcs

DESCRIPTION="A Library for Large Linear Classification"
HOMEPAGE="http://www.csie.ntu.edu.tw/~cjlin/liblinear/ https://github.com/cjlin1/liblinear"
SRC_URI="https://github.com/cjlin1/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"

src_prepare() {
	sed -i \
		-e '/^AR/s|=|?=|g' \
		-e '/^RANLIB/s|=|?=|g' \
		-e '/^CFLAGS/d;/^CXXFLAGS/d' \
		blas/Makefile || die
	sed -i \
		-e 's|make|$(MAKE)|g' \
		-e '/$(LIBS)/s|$(CFLAGS)|& $(LDFLAGS)|g' \
		-e '/^CFLAGS/d;/^CXXFLAGS/d' \
		-e 's|$${SHARED_LIB_FLAG}|& $(LDFLAGS)|g' \
		Makefile || die
}

src_compile() {
	CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS} -fPIC" \
		CXXFLAGS="${CXXFLAGS} -fPIC" \
		AR="$(tc-getAR) rcv" \
		RANLIB="$(tc-getRANLIB)" \
		emake lib all
}

src_install() {
	dolib ${PN}.so.2
	dosym ${PN}.so.2 /usr/$(get_libdir)/${PN}.so

	newbin predict ${PN}-predict
	newbin train ${PN}-train

	insinto /usr/include
	doins linear.h

	dodoc README
}
