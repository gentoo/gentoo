# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="Advanced plugin and service introspection"
LICENSE="LGPL-2 LGPL-2.1+"
KEYWORDS="amd64 ~arm ~x86"
IUSE="+man"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	dev-qt/qtdbus:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	man? ( $(add_frameworks_dep kdoctools) )
	test? ( dev-qt/qtconcurrent:5 )
"

# requires running kde environment
RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package man KF5DocTools)
	)

	kde5_src_configure
}
