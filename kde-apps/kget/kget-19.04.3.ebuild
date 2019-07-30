# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Advanced download manager by KDE"
HOMEPAGE="https://kde.org/applications/internet/kget/"
KEYWORDS="amd64 arm64 x86"
IUSE="bittorrent gpg kde mms sqlite"

RDEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	app-crypt/qca:2[qt5(+)]
	bittorrent? ( net-libs/libktorrent:5 )
	gpg? ( app-crypt/gpgme[qt5] )
	kde? ( $(add_plasma_dep libkworkspace) )
	mms? ( media-libs/libmms )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package bittorrent KF5Torrent)
		$(cmake-utils_use_find_package gpg Gpgmepp)
		$(cmake-utils_use_find_package kde LibKWorkspace)
		$(cmake-utils_use_find_package mms LibMms)
		$(cmake-utils_use_find_package sqlite Sqlite)
	)

	kde5_src_configure
}
