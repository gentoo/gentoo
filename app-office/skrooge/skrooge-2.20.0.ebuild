# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Personal finances manager, aiming at being simple and intuitive"
HOMEPAGE="https://skrooge.org/"
[[ ${PV} == 9999 ]] || SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="activities designer kde ofx webkit"

REQUIRED_USE="test? ( designer )"

BDEPEND="
	dev-libs/libxslt
	virtual/pkgconfig
"
COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative 'widgets')
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtsql '' '' '5=')
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	app-crypt/qca:2[qt5(+)]
	dev-db/sqlcipher
	dev-libs/grantlee:5
	activities? ( $(add_frameworks_dep kactivities) )
	kde? ( $(add_frameworks_dep krunner) )
	ofx? ( dev-libs/libofx )
	webkit? ( >=dev-qt/qtwebkit-5.212.0_pre20180120:5 )
	!webkit? ( $(add_qt_dep qtwebengine 'widgets') )
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kwindowsystem)
	designer? (
		$(add_frameworks_dep kdesignerplugin)
		$(add_qt_dep designer)
	)
"
RDEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtquickcontrols)
"

PATCHES=( "${FILESDIR}"/${P}-missing-header.patch )

# hangs + installs files
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		-DSKG_BUILD_TEST=$(usex test)
		-DSKG_DESIGNER=$(usex designer)
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package kde KF5Runner)
		$(cmake_use_find_package ofx LibOfx)
		-DSKG_WEBENGINE=$(usex !webkit)
	)

	kde5_src_configure
}

src_test() {
	local mycmakeargs=(
		-DSKG_BUILD_TEST=ON
	)
	kde5_src_test
}
