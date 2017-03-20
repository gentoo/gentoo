# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit fdo-mime qmake-utils

DESCRIPTION="A small, lightweight file manager for desktops based on pure Qt"
HOMEPAGE="http://www.qtfm.org/"
SRC_URI="http://www.qtfm.org/${P}.tar.gz?attredirects=0 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

# file is for LIBS += -lmagic
RDEPEND="sys-apps/file
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gcc6.patch )

src_prepare() {
	default
	sed -i \
		-e "/^docs.path/s:qtfm:${PF}:" \
		-e '/^docs.files/s: COPYING::' \
		${PN}.desktop || die
	sed -i \
		-e '/MimeType=/s|$|;|' \
		-e '/Categories=/s|$|;System;FileTools;|' \
		${PN}.desktop || die
}

src_configure() {
	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
