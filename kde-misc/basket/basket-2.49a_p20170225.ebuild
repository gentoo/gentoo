# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT="8de0345d99f3eb08d9406bd07e88b31afe46f315"
KDE_TEST="true"
KDE_HANDBOOK="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5 vcs-snapshot

DESCRIPTION="A DropDrawers clone. Multiple information organizer"
HOMEPAGE="http://basket.kde.org/ https://github.com/basket-notepads/basket"
SRC_URI="https://github.com/${PN}-notepads/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="crypt git"

RDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kfilemetadata)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	media-libs/phonon[qt5]
	x11-libs/libX11
	crypt? ( app-crypt/gpgme )
	git? ( dev-libs/libgit2 )
"
DEPEND="${RDEPEND}
	$(add_qt_dep qtconcurrent)
"

src_prepare() {
	kde5_src_prepare
	if ! use test; then
		sed -e "/add_subdirectory(tests/s/^/#DONT/" -i src/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package crypt Gpgme)
		$(cmake-utils_use_find_package git Libgit2)
	)
	kde5_src_configure
}
