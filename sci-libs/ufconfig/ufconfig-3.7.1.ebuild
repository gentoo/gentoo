# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

MY_PN=UFconfig
DESCRIPTION="Common configuration scripts for the SuiteSparse libraries"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/UFconfig"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="static-libs"

src_compile() {
	elog "Running: $(tc-getCC) ${CFLAGS} -fPIC -c UFconfig.c -o UFconfig.lo"
	$(tc-getCC) ${CFLAGS} -fPIC -c UFconfig.c -o UFconfig.lo || die

	local sharedlink="-shared -Wl,-soname,libufconfig$(get_libname ${PV})"
	if [[ ${CHOST} == *-darwin* ]]; then
		sharedlink="-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libufconfig$(get_libname ${PV})"
	fi

	elog "Running: $(tc-getCC) ${LDFLAGS} ${sharedlink} -o libufconfig$(get_libname ${PV}) UFconfig.lo"
	$(tc-getCC) ${LDFLAGS} ${sharedlink} -o libufconfig$(get_libname ${PV}) UFconfig.lo || die

	if use static-libs; then
		elog "Running: $(tc-getCC) ${CFLAGS} -c UFconfig.c -o UFconfig.o"
		$(tc-getCC) ${CFLAGS} -c UFconfig.c -o UFconfig.o || die

		elog "Running: $(tc-getAR) libufconfig.a UFconfig.o"
		$(tc-getAR) cr libufconfig.a UFconfig.o || die
	fi
}

src_install() {
	dolib.so libufconfig$(get_libname ${PV})
	dosym libufconfig$(get_libname ${PV}) /usr/$(get_libdir)/libufconfig$(get_libname)
	use static-libs && dolib.a libufconfig.a
	insinto /usr/include
	doins UFconfig.h
	dodoc README.txt
}
