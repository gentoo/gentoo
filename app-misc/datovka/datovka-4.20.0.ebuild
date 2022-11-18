# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg-utils

DESCRIPTION="GUI to access the Czech data box e-government system"
HOMEPAGE="https://www.datovka.cz/"
SRC_URI="https://secure.nic.cz/files/datove_schranky/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# minimum Qt version required
QT_PV="5.14.0:5"

RDEPEND="
	>=dev-libs/openssl-1.0.2:0=
	>=dev-qt/qtcore-${QT_PV}
	>=dev-qt/qtgui-${QT_PV}
	>=dev-qt/qtnetwork-${QT_PV}[ssl]
	>=dev-qt/qtprintsupport-${QT_PV}
	>=dev-qt/qtsql-${QT_PV}[sqlite]
	>=dev-qt/qtsvg-${QT_PV}
	>=dev-qt/qtwidgets-${QT_PV}
	>=net-libs/libisds-0.11
	>=app-misc/libdatovka-0.2.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-qt/linguist-tools-${QT_PV}
	virtual/pkgconfig
"

DOCS=( ChangeLog README )

src_configure() {
	$(qt5_get_bindir)/lrelease datovka.pro || die
	eqmake5 PREFIX="/usr" DISABLE_VERSION_NOTIFICATION=1 TEXT_FILES_INST_DIR="/usr/share/${PN}/"
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
