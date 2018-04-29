# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit multilib toolchain-funcs

MY_PN=UFconfig
DESCRIPTION="Common configuration scripts for the SuiteSparse libraries"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/UFconfig"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="static-libs"
DEPEND=""

S="${WORKDIR}/${MY_PN}"

src_compile() {
	echo  "$(tc-getCC) ${CFLAGS} -fPIC -c UFconfig.c -o UFconfig.lo"
	$(tc-getCC) ${CFLAGS} -fPIC -c UFconfig.c -o UFconfig.lo || die
	echo "$(tc-getCC) ${LDFLAGS} -shared -Wl,-soname,libufconfig.so.${PV} -o libufconfig.so.${PV} UFconfig.lo"
	$(tc-getCC) ${LDFLAGS} -shared -Wl,-soname,libufconfig.so.${PV} -o libufconfig.so.${PV} UFconfig.lo || die
	if use static-libs; then
		echo "$(tc-getCC) ${CFLAGS} -c UFconfig.c -o UFconfig.o"
		$(tc-getCC) ${CFLAGS} -c UFconfig.c -o UFconfig.o || die
		echo "$(tc-getAR) libufconfig.a UFconfig.o"
		$(tc-getAR) cr libufconfig.a UFconfig.o
	fi
}

src_install() {
	dolib.so libufconfig.so.${PV} || die
	dosym libufconfig.so.${PV} /usr/$(get_libdir)/libufconfig.so
	if use static-libs; then
		dolib.a libufconfig.a || die
	fi
	insinto /usr/include
	doins UFconfig.h || die
	dodoc README.txt || die
}
