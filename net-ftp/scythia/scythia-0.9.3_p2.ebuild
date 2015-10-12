# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit gnome2-utils qt4-r2

DESCRIPTION="Just a small FTP client"
HOMEPAGE="http://scythia.free.fr/"
SRC_URI="http://scythia.free.fr/wp-content/${PN}_${PV/_p/-}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"

S=${WORKDIR}/${PN}

DOCS="AUTHORS"

src_prepare() {
	sed -i \
		-e 's:/usr/share/applnk/Internet:/usr/share/applications:g' \
		-e "s:scythia/html:${PF}/html:" \
		scythia.pro || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
