# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
KMNAME="${PN}-kde"
KDE_SELINUX_MODULE="${PN}"
inherit kde5

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${KMNAME}-${PV}.tar.xz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Adds communication between KDE Plasma and your smartphone"
HOMEPAGE="https://kde.org/ https://community.kde.org/KDEConnect"
LICENSE="GPL-2+"
IUSE="app bluetooth mousepad wayland"

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
	>=app-crypt/qca-2.1.0:2[qt5(+),ssl]
	app? ( $(add_frameworks_dep kdeclarative) )
	bluetooth? ( $(add_qt_dep qtbluetooth) )
	mousepad? (
		x11-libs/libfakekey
		x11-libs/libX11
		x11-libs/libXtst
	)
	wayland? ( $(add_frameworks_dep kwayland) )
"
RDEPEND="${DEPEND}
	net-fs/sshfs
	app? ( $(add_frameworks_dep kirigami) )
	!kde-misc/kdeconnect:4
"

RESTRICT+=" test"

PATCHES=( "${FILESDIR}/${PN}-1.3.0-no-wayland.patch" )

src_configure() {
	local mycmakeargs=(
		-DEXPERIMENTALAPP_ENABLED=$(usex app)
		-DBLUETOOTH_ENABLED=$(usex bluetooth)
		$(cmake_use_find_package mousepad LibFakeKey)
		$(cmake_use_find_package wayland KF5Wayland)
	)

	kde5_src_configure
}

pkg_postinst(){
	kde5_pkg_postinst

	elog "The Android .apk file is available via"
	elog "https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp"
	elog "or via"
	elog "https://f-droid.org/repository/browse/?fdid=org.kde.kdeconnect_tp"
}
