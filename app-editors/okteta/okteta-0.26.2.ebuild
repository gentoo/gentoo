# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Hex editor by KDE"
HOMEPAGE="https://kde.org/applications/utilities/okteta
https://utils.kde.org/projects/okteta/"
IUSE="crypt designer"

DEPEND="
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtscript 'scripttools')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	crypt? ( app-crypt/qca:2[qt5(+)] )
	designer? ( $(add_qt_dep designer) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DOMIT_EXAMPLES=ON
		$(cmake_use_find_package crypt Qca-qt5)
		-DBUILD_DESIGNERPLUGIN=$(usex designer)
	)

	kde5_src_configure
}

src_test() {
	local myctestargs=( -j1 )

	kde5_src_test
}
