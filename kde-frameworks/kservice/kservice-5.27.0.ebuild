# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
		$(cmake-utils_use_find_package man KF5DocTools)
	)

	kde5_src_configure
}
