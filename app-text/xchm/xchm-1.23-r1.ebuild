# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
WX_GTK_VER="3.0"

inherit eutils fdo-mime flag-o-matic wxwidgets

DESCRIPTION="Utility for viewing Compiled HTML Help (CHM) files"
HOMEPAGE="http://xchm.sourceforge.net/"
SRC_URI="mirror://sourceforge/xchm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""
DEPEND=">=dev-libs/chmlib-0.36
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-wx3.0-compat.patch

	append-flags -Wno-unused-local-typedefs
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS README ChangeLog

	cp "${D}"/usr/share/pixmaps/xchm-32.xpm "${D}"/usr/share/pixmaps/xchm.xpm
	rm -f "${D}"/usr/share/pixmaps/xchm-*.xpm
	rm -f "${D}"/usr/share/pixmaps/xchmdoc*.xpm

	domenu "${FILESDIR}"/xchm.desktop
	insinto /usr/share/mime/packages
	doins "${FILESDIR}"/xchm.xml
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
