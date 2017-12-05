# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils xdg-utils

CM_PV="5.18.2"

DESCRIPTION="Notepad++-like editor for Linux"
HOMEPAGE="http://notepadqq.altervista.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# Silence a QA warning
	sed '/^OnlyShowIn/d' \
		-i support_files/shortcuts/notepadqq.desktop \
		|| die
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr" ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
