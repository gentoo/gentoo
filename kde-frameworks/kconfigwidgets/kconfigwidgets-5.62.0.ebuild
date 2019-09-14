# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_DESIGNERPLUGIN="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing an assortment of configuration-related widgets"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+man"

BDEPEND="
	man? ( $(add_frameworks_dep kdoctools) )
"
DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package man KF5DocTools)
	)

	kde5_src_configure
}
