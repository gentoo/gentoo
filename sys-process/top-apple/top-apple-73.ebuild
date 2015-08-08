# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs eutils

DESCRIPTION="Apple's top from Mac OS X Lion 10.7"
HOMEPAGE="http://www.opensource.apple.com/"
SRC_URI="
	http://www.opensource.apple.com/tarballs/top/top-${PV}.tar.gz
	http://www.opensource.apple.com/source/libutil/libutil-11/libutil.h?txt -> libutil-11-top-${PV}.h"

LICENSE="APSL-2 BSD"
SLOT="0"
KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

S=${WORKDIR}/top-${PV}

src_prepare() {
	# libutil.h header is missing at least on Leopard (10.5), the dylib just
	# exists
	[[ ! -e ${ROOT}/usr/include/libutil.h ]] && \
		cp "${DISTDIR}"/libutil-11-top-${PV}.h "${S}"/libutil.h || die
	epatch "${FILESDIR}"/${P}-darwin9.patch
}

src_compile() {
	local libs="-lutil -lpanel -lncurses -framework CoreFoundation -framework IOKit"
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o top -I." *.c ${libs}
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o top -I. *.c ${libs} || die
}

src_install() {
	dobin top
}

pkg_postinst() {
	ewarn "To use top, you need to perform the following commands:"
	ewarn "  % sudo chown root ${EPREFIX}/usr/bin/top"
	ewarn "  % sudo chmod u+s ${EPREFIX}/usr/bin/top"
}
