# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FRAMEWORKS_MINIMAL="5.42.0"
KDE_HANDBOOK="optional"
KDE_TEST="true"
KMNAME="${PN}-kde"
KDE_SELINUX_MODULE="${PN}"
inherit kde5

DESCRIPTION="Adds communication between KDE Plasma and your smartphone"
HOMEPAGE="https://www.kde.org/ https://community.kde.org/KDEConnect"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${KMNAME}-v${PV}.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="app wayland"

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
	>=app-crypt/qca-2.1.0:2[qt5,ssl]
	x11-libs/libfakekey
	x11-libs/libX11
	x11-libs/libXtst
	app? ( $(add_frameworks_dep kdeclarative) )
	wayland? ( $(add_frameworks_dep kwayland) )
"
RDEPEND="${DEPEND}
	app? ( $(add_frameworks_dep kirigami) )
	wayland? ( $(add_plasma_dep kwin) )
	!kde-misc/kdeconnect:4
"

RESTRICT+=" test"

S="${WORKDIR}/${KMNAME}-v${PV}"

src_prepare() {
	sed \
		-e 's#${LIBEXEC_INSTALL_DIR}#@KDE_INSTALL_FULL_LIBEXECDIR@#' \
		-i daemon/kdeconnectd.desktop.cmake || die

	kde5_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DEXPERIMENTALAPP_ENABLED=$(usex app)
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
	elog "or via"
	elog "https://f-droid.org/repository/browse/?fdid=org.kde.kdeconnect_tp"
	elog
}
