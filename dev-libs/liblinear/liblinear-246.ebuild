# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib toolchain-funcs

MY_PV="${PV:0:1}.${PV:1}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A Library for Large Linear Classification"
HOMEPAGE="https://www.csie.ntu.edu.tw/~cjlin/liblinear/ https://github.com/cjlin1/liblinear"
SRC_URI="https://www.csie.ntu.edu.tw/~cjlin/liblinear/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

src_prepare() {
	default

	sed -i \
		-e '/^CFLAGS/d;/^CXXFLAGS/d' \
		blas/Makefile || die
	sed -i \
		-e 's|make|$(MAKE)|g' \
		-e '/$(LIBS)/s|$(CFLAGS)|& $(LDFLAGS)|g' \
		-e '/^CFLAGS/d;/^CXXFLAGS/d' \
		-e 's|$(SHARED_LIB_FLAG)|& $(LDFLAGS)|g' \
		Makefile || die

	# fix install_name on Darwin
	sed -i \
		-e '/install_name/s:liblinear.so.$(SHVER):'"${EPREFIX}"'/usr/lib/liblinear.$(SHVER).dylib:' \
		-e '/LDFLAGS/s:liblinear.so.$(SHVER):liblinear'"$(get_libname '$(SHVER)')"':' \
		Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS} -fPIC" \
		CXXFLAGS="${CXXFLAGS} -fPIC" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		lib all
}

src_install() {
	dolib.so ${PN}$(get_libname ${SLOT#*/})
	dosym ${PN}$(get_libname ${SLOT#*/}) /usr/$(get_libdir)/${PN}$(get_libname)

	newbin predict ${PN}-predict
	newbin train ${PN}-train

	doheader linear.h

	dodoc README
}
