# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils qmake-utils

DESCRIPTION="GUI to access the Czech eGov system of Datove schranky"
HOMEPAGE="https://www.datovka.cz/"
SRC_URI="https://secure.nic.cz/files/datove_schranky/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# minimum Qt version required
QT_PV="5.3.2:5"

RDEPEND="
	>=dev-libs/openssl-1.0.2
	>=dev-qt/qtcore-${QT_PV}
	>=dev-qt/qtgui-${QT_PV}
	>=dev-qt/qtnetwork-${QT_PV}
	>=dev-qt/qtprintsupport-${QT_PV}
	>=dev-qt/qtsql-${QT_PV}[sqlite]
	>=dev-qt/qtsvg-${QT_PV}
	>=dev-qt/qtwidgets-${QT_PV}
	>=net-libs/libisds-0.10.8
"
DEPEND="
	${RDEPEND}
	>=dev-qt/linguist-tools-${QT_PV}
"

DOCS=( ChangeLog README )

src_configure() {
	lrelease datovka.pro || die
	eqmake5 PREFIX="/usr" DISABLE_VERSION_NOTIFICATION=1 TEXT_FILES_INST_DIR="/usr/share/${PN}/"
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	einstalldocs
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
