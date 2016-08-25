# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KDE_TEST="true"
KMNAME="${PN}-kde"
inherit kde5

DESCRIPTION="Adds communication between KDE and your smartphone"
HOMEPAGE="https://www.kde.org/ https://community.kde.org/KDEConnect"
SRC_URI="mirror://kde/unstable/${PN}/0.9/src/${KMNAME}-${PV}.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="app +telepathy wayland"

DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	>=app-crypt/qca-2.1.0:2[qt5,openssl]
	x11-libs/libfakekey
	x11-libs/libX11
	x11-libs/libXtst
	app? ( $(add_frameworks_dep kdeclarative) )
	telepathy? ( >=net-libs/telepathy-qt-0.9.7[qt5] )
	wayland? ( $(add_frameworks_dep kwayland '' 5.5.5) )
"
RDEPEND="${DEPEND}
	$(add_plasma_dep plasma-workspace)
	wayland? ( $(add_plasma_dep kwin) )
	!kde-misc/kdeconnect:4
"

src_prepare() {
	sed \
		-e 's#${LIBEXEC_INSTALL_DIR}#@KDE_INSTALL_FULL_LIBEXECDIR@#' \
		-i daemon/kdeconnectd.desktop.cmake || die

	kde5_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DEXPERIMENTALAPP_ENABLED=$(usex app)
		$(cmake-utils_use_find_package telepathy TelepathyQt5)
		$(cmake-utils_use_find_package telepathy TelepathyQt5Service)
		$(cmake-utils_use_find_package wayland KF5Wayland)
	)

	kde5_src_configure
}

pkg_postinst(){
	kde5_pkg_postinst

	elog
	elog "Optional dependency:"
	elog "net-fs/sshfs (for 'remote filesystem browser' plugin)"
	elog
	elog "The Android .apk file is available via"
	elog "https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp"
	elog
}
