# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils qmake-utils xdg-utils

DESCRIPTION="Qt app to show where your disk space has gone and to help you clean it up"
HOMEPAGE="https://github.com/shundhammer/qdirstat"
SRC_URI="https://github.com/shundhammer/qdirstat/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-qt/qtgui:5
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
