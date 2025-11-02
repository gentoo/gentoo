# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# minimum Qt version required
QTMIN=6.7.2
inherit qmake-utils xdg-utils

DESCRIPTION="GUI to access the Czech data box e-government system"
HOMEPAGE="https://www.datovka.cz/cs/"
SRC_URI="https://secure.nic.cz/files/datove_schranky/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/openssl-1.1.1:=
	>=dev-libs/quazip-1.4:=[qt6(+)]
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,sql,sqlite,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwebsockets-${QTMIN}:6
	>=app-misc/libdatovka-0.7.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-qt/qttools-${QTMIN}:6[linguist]
	virtual/pkgconfig
"

DOCS=( ChangeLog README )

src_configure() {
	$(qt6_get_bindir)/lrelease datovka.pro || die
	eqmake6 PREFIX="/usr" SYSTEM_LIBQUAZIP=1 DISABLE_VERSION_NOTIFICATION=1 TEXT_FILES_INST_DIR="/usr/share/${PN}/"
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
