# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Advanced plugin and service introspection"
LICENSE="LGPL-2 LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+man"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtxml)
"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	man? ( $(add_frameworks_dep kdoctools) )
	test? ( $(add_qt_dep qtconcurrent) )
"

# requires running kde environment
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		-DAPPLICATIONS_MENU_NAME=kf5-applications.menu
		$(cmake-utils_use_find_package man KF5DocTools)
	)

	kde5_src_configure
}

src_install() {
	kde5_src_install

	# bug 596316
	dosym /etc/xdg/menus/kf5-applications.menu /etc/xdg/menus/applications.menu
}
