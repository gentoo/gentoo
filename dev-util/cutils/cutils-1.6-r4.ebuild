# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="C language utilities"
HOMEPAGE="http://www.sigala.it/sandro/software.php#cutils"
SRC_URI="http://www.sigala.it/sandro/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/flex"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-infopage.patch

	epatch "${FILESDIR}"/${P}-case-insensitive.patch

	mv "${S}"/src/cdecl/cdecl.1 			\
		"${S}"/src/cdecl/cutils-cdecl.1 || die
	# Force rebuild of cutils.info
	rm -f "${S}"/doc/cutils.info || die

	sed -e "s/cdecl/cutils-cdecl/g"	\
		-i "${S}"/doc/cutils.texi || die
	sed -e "/PROG/s/cdecl/cutils-cdecl/" \
		-i "${S}"/src/cdecl/Makefile.in || die
	sed -e "/Xr/s/cdecl/cutils-cdecl/" \
		-i "${S}"/src/cundecl/cundecl.1 || die
	sed -i "/Nm/s/cdecl/cutils-cdecl/" \
		"${S}"/src/cdecl/cutils-cdecl.1 || die
}

src_compile() {
	emake CC="$(tc-getCC)" -j1
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc CREDITS HISTORY NEWS README
}

pkg_postinst () {
	elog "cdecl was installed as cutils-cdecl because of a naming conflict"
	elog "with dev-util/cdecl."
}
