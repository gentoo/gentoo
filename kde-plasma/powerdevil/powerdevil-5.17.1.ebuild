# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Power management for KDE Plasma Shell"
HOMEPAGE="https://cgit.kde.org/powerdevil.git"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="brightness-control +wireless"

DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kauth policykit)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwayland)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_plasma_dep libkscreen)
	$(add_plasma_dep libkworkspace)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	virtual/libudev:=
	x11-libs/libxcb
	brightness-control? ( app-misc/ddcutil )
	wireless? (
		$(add_frameworks_dep bluez-qt)
		$(add_frameworks_dep networkmanager-qt)
	)
"
RDEPEND="${DEPEND}
	$(add_plasma_dep kde-cli-tools)
	>=sys-power/upower-0.9.23
"

src_configure() {
	local mycmakeargs=(
		-DHAVE_DDCUTIL=$(usex brightness-control)
		$(cmake-utils_use_find_package wireless KF5BluezQt)
		$(cmake-utils_use_find_package wireless KF5NetworkManagerQt)
	)

	kde5_src_configure
}
