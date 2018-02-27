# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
QT_MINIMAL="5.9.2"
inherit kde5

DESCRIPTION="Cross-platform web browser using QtWebEngine"
HOMEPAGE="https://www.qupzilla.com/"
if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV%.0}/src/${P}.tar.xz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus gnome-keyring kwallet libressl +X"

COMMON_DEPEND="
	$(add_qt_dep qtdeclarative 'widgets')
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork 'ssl')
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsql 'sqlite')
	$(add_qt_dep qtwebchannel)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	dbus? ( $(add_qt_dep qtdbus) )
	gnome-keyring? ( gnome-base/gnome-keyring )
	kwallet? ( $(add_frameworks_dep kwallet) )
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libxcb:=
	)
"
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep linguist-tools)
	$(add_qt_dep qtconcurrent)
	gnome-keyring? ( virtual/pkgconfig )
"
RDEPEND="${COMMON_DEPEND}
	!www-client/qupzilla
	$(add_qt_dep qtsvg)
"

src_configure() {
	local mycmakeargs=(
		-DDISABLE_DBUS=$(usex !dbus)
		-DBUILD_KEYRING=$(usex gnome-keyring)
		$(cmake-utils_use_find_package kwallet KF5Wallet)
		-DNO_X11=$(usex !X)
	)
	kde5_src_configure
}
