# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
WX_GTK_VER="3.0-gtk3"

inherit wxwidgets xdg-utils

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

PATCHES=( "${FILESDIR}"/${P}-wx3.0-compat.patch )

src_prepare() {
	setup-wxwidgets
	default
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
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
