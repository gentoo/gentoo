# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib toolchain-funcs

DESCRIPTION="library for a virtual ring buffer"
HOMEPAGE="http://phil.ipal.org/freeware/vrb/"
SRC_URI="http://phil.ipal.org/freeware/vrb/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

src_compile() {
	#respecting CFLAGS and LDFLAGS
	sed -i "s/copts=\"-pipe -O2\"/copts=\"${CFLAGS} ${LDFLAGS}\"/g" Configure
	sed -i "s/gcc -v/\${CC} \${COPTS}/g" Configure

	#respecting CC
	sed -i "s/gcc/\${CC}/g" Configure

	#omiting -Werror
	sed -i "s/-Werror//g" Configure

	CC="$(tc-getCC)" ./Configure 						\
		--prefix=/usr || die "./Configure failed"

	emake || die "emake failed"
}

src_install() {
	insinto /usr/include/libvrb/
	doins include/vrb.h

	dolib.so lib/libvrb.so.0.3.0

	dosym libvrb.so.0.3.0 /usr/$(get_libdir)/libvrb.so.0.3
	dosym libvrb.so.0.3.0 /usr/$(get_libdir)/libvrb.so.0
	dosym libvrb.so.0.3.0 /usr/$(get_libdir)/libvrb.so

	dobin bin/iobuffer

	dodoc README
}
