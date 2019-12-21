# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Free/Open Source micro-blogging client by KDE"
HOMEPAGE="https://choqok.kde.org/"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="amd64 x86"
IUSE="attica konqueror telepathy"

DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kemoticons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetworkauth)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	app-crypt/qca[qt5(+)]
	attica? ( $(add_frameworks_dep attica) )
	konqueror? (
		$(add_frameworks_dep kparts)
		$(add_frameworks_dep kdewebkit)
		>=dev-qt/qtwebkit-5.212.0_pre20180120:5
	)
	telepathy? ( net-libs/telepathy-qt[qt5(+)] )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package attica KF5Attica)
		$(cmake_use_find_package konqueror KF5Parts)
		$(cmake_use_find_package konqueror KF5WebKit)
		$(cmake_use_find_package telepathy TelepathyQt5)
	)

	kde5_src_configure
}

PATCHES=( "${FILESDIR}"/${P}-missing-header.patch )
