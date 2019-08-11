# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib toolchain-funcs

DESCRIPTION="A Library for Large Linear Classification"
HOMEPAGE="https://www.csie.ntu.edu.tw/~cjlin/liblinear/ https://github.com/cjlin1/liblinear"
SRC_URI="https://github.com/cjlin1/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/3"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"

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
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS} -fPIC" \
		CXXFLAGS="${CXXFLAGS} -fPIC" \
		AR="$(tc-getAR) rcv" \
		RANLIB="$(tc-getRANLIB)" \
		lib all
}

src_install() {
	dolib ${PN}.so.3
	dosym ${PN}.so.3 /usr/$(get_libdir)/${PN}.so

	newbin predict ${PN}-predict
	newbin train ${PN}-train

	doheader linear.h

	dodoc README
}
