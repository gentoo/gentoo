# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Mike's Arbitrary Precision Math Library"
HOMEPAGE="http://www.tc.umn.edu/~ringx004/mapm-main.html"
SRC_URI="http://www.tc.umn.edu/~ringx004/${P}.tar.gz"

LICENSE="mapm-4.9.5"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}_${PV}"

src_prepare() {
	epatch "${FILESDIR}/${PV}-missing_include.patch"
}

src_compile() {
	$(tc-getCC) -c -Wall ${CFLAGS} -fPIC map*.c || die "compiling sources failed"
	$(tc-getCC) -shared ${LDFLAGS} -Wl,--soname=libmapm.so -o libmapm.so.0 map*.o || die "linking sources failed"
}

src_install() {
	dolib.so libmapm.so.0
#	dosym libmapm.so.0 /usr/$(get_libdir)/libmapm.so

	insinto /usr/include
	doins m_apm.h

	insinto /usr/share/doc/${PF}/examples
	doins calc.c validate.c primenum.c cpp_demo.cpp

	cd DOCS
	dodoc README article.pdf algorithms.used commentary.txt \
		cpp_function.ref function.ref history.txt struct.ref

}
