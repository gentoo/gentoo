# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="COBOL for linux"
HOMEPAGE="http://tiny-cobol.sourceforge.net/"
SRC_URI="mirror://sourceforge/tiny-cobol/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE=""
KEYWORDS="ppc x86"

RDEPEND=">=dev-libs/glib-2.0
	sys-libs/db
	dev-db/vbisam"

DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}.patch"
}

src_compile() {
	econf || die
	emake CC="$(tc-getCC)" || die "make failed"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	dodir /usr/lib
	dodir /usr/share/htcobol
	dodir /usr/share/doc
	emake DESTDIR="${D}" cobdir_docdir="/usr/share/doc/htcobol-${PV}" \
			pkgdatadir="/usr/share/htcobol/" install
	cd lib
	emake DESTDIR="${D}" pkgdatadir="/usr/share/htcobol/" install \
			install-shared-libs install-static-libs
	rm -rf "${D}/usr/man" # empty dir, see bug #315401
}
