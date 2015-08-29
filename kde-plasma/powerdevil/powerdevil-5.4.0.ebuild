# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="Power management for KDE Plasma Shell"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/powerdevil"
KEYWORDS=" ~amd64"
IUSE="systemd"

DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kauth policykit)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_plasma_dep libkscreen)
	$(add_plasma_dep plasma-workspace)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	virtual/libudev:=
	x11-libs/libxcb
"

RDEPEND="${DEPEND}
	$(add_plasma_dep kde-cli-tools)
	|| ( sys-power/upower-pm-utils >=sys-power/upower-0.9.23 )
	!systemd? ( sys-auth/polkit-pkla-compat )
	!kde-base/powerdevil
	!kde-base/systemsettings[handbook]
"

src_install() {
	kde5_src_install

	if ! use systemd ; then
		insinto /etc/polkit-1/localauthority/10-vendor.d/
		doins "${FILESDIR}"/10-org.freedesktop.upower.pkla
		doins "${FILESDIR}"/20-org.freedesktop.consolekit.system.stop-multiple-users.pkla
		doins "${FILESDIR}"/30-org.freedesktop.consolekit.system.restart-multiple-users.pkla
	fi
}

pkg_postinst() {
	kde5_pkg_postinst

	if ! has_version sys-power/upower-pm-utils && ! use systemd ; then
		ewarn "Suspend and hibernate will not be available as it requires sys-power/upower-pm-utils"
		ewarn "on non-systemd systems. Please install it if you require this functionality."
	fi
}
