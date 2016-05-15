# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fdo-mime gnome2-utils qmake-utils

MY_P=${PN}-${PV%0}-src

DESCRIPTION="Qt5 application to design electric diagrams"
HOMEPAGE="http://qelectrotech.org/"
SRC_URI="http://download.tuxfamily.org/qet/tags/20151127/${MY_P}.tar.gz"

LICENSE="CC-BY-3.0 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"

S=${WORKDIR}/${MY_P}

DOCS=( CREDIT ChangeLog README )

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.3-fix-paths.patch"
}

src_configure() {
	eqmake5 ${PN}.pro
}
src_install() {
	emake INSTALL_ROOT="${D}" install

	einstalldocs

	if use doc; then
		doxygen Doxyfile || die
		dodoc -r doc/html
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
