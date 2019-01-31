# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit xdg-utils gnome2-utils qmake-utils

DESCRIPTION="A small, lightweight file manager for desktops based on pure Qt"
HOMEPAGE="https://qtfm.eu/"
SRC_URI="https://github.com/rodlie/qtfm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	sys-apps/file
"
DEPEND="
	${RDEPEND}
	app-arch/unzip
	dev-qt/linguist-tools:5
"

src_prepare() {
	sed -i -e '/^docs.path/ s:$${TARGET}-$${VERSION}:'"${PF}"':g' fm/fm.pro || die
	default
}

src_configure() {
	eqmake5 PREFIX=/usr XDGDIR=/etc/xdg
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
