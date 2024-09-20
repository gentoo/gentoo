# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Apple's top from Mac OS X Lion 10.7"
HOMEPAGE="http://www.opensource.apple.com/"
SRC_URI="
	http://www.opensource.apple.com/tarballs/top/top-${PV}.tar.gz
	http://www.opensource.apple.com/source/libutil/libutil-11/libutil.h?txt -> libutil-11-top-${PV}.h"
S="${WORKDIR}/top-${PV}"

LICENSE="APSL-2 BSD"
SLOT="0"
KEYWORDS="~ppc-macos ~x64-macos"

src_prepare() {
	# libutil.h header is missing at least on Leopard (10.5), the dylib just
	# exists
	[[ ! -e ${ESYSROOT}/usr/include/libutil.h ]] && \
		cp "${DISTDIR}"/libutil-11-top-${PV}.h "${S}"/libutil.h || die
	eapply -p0 "${FILESDIR}"/${P}-darwin9.patch

	eapply_user
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
