# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_GCC_MINIMAL="4.8"
KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="Power management for KDE Plasma Shell"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/powerdevil"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="consolekit +wireless"

DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kauth policykit)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
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
	$(add_plasma_dep plasma-workspace)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	virtual/libudev:=
	x11-libs/libxcb
	wireless? (
		$(add_frameworks_dep bluez-qt)
		$(add_frameworks_dep networkmanager-qt)
	)
"

RDEPEND="${DEPEND}
	$(add_plasma_dep kde-cli-tools)
	>=sys-power/upower-0.9.23
	consolekit? (
		>=sys-auth/consolekit-1.0.1
		sys-auth/polkit-pkla-compat
		sys-power/pm-utils
	)
	!kde-plasma/powerdevil:4
	!kde-plasma/systemsettings:4[handbook]
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package wireless KF5BluezQt)
		$(cmake-utils_use_find_package wireless KF5NetworkManagerQt)
	)

	kde5_src_configure
}

src_install() {
	kde5_src_install

	if use consolekit ; then
		insinto /etc/polkit-1/localauthority/10-vendor.d/
		doins "${FILESDIR}"/10-org.freedesktop.upower.pkla
		doins "${FILESDIR}"/20-org.freedesktop.consolekit.system.stop-multiple-users.pkla
		doins "${FILESDIR}"/30-org.freedesktop.consolekit.system.restart-multiple-users.pkla
		doins "${FILESDIR}"/40-org.freedesktop.consolekit.system.suspend-multiple-users.pkla
		doins "${FILESDIR}"/50-org.freedesktop.consolekit.system.hibernate-multiple-users.pkla
	fi
}
