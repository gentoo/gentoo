# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ufconfig/ufconfig-3.7.0.ebuild,v 1.3 2012/05/30 13:28:19 aballier Exp $

EAPI=4
inherit multilib toolchain-funcs

MY_PN=UFconfig
DESCRIPTION="Common configuration scripts for the SuiteSparse libraries"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/UFconfig"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="static-libs"
DEPEND=""

S="${WORKDIR}/${MY_PN}"

src_compile() {
	echo  "$(tc-getCC) ${CFLAGS} -fPIC -c UFconfig.c -o UFconfig.lo"
	$(tc-getCC) ${CFLAGS} -fPIC -c UFconfig.c -o UFconfig.lo || die
	local sharedlink="-shared -Wl,-soname,libufconfig$(get_libname ${PV})"
	[[ ${CHOST} == *-darwin* ]] && \
		sharedlink="-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libufconfig$(get_libname ${PV})"
	echo "$(tc-getCC) ${LDFLAGS} ${sharedlink} -o libufconfig$(get_libname ${PV}) UFconfig.lo"
	$(tc-getCC) ${LDFLAGS} ${sharedlink} -o libufconfig$(get_libname ${PV}) UFconfig.lo || die
	if use static-libs; then
		echo "$(tc-getCC) ${CFLAGS} -c UFconfig.c -o UFconfig.o"
		$(tc-getCC) ${CFLAGS} -c UFconfig.c -o UFconfig.o || die
		echo "$(tc-getAR) libufconfig.a UFconfig.o"
		$(tc-getAR) cr libufconfig.a UFconfig.o
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
