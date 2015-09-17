# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="Framework providing advanced features for plugins, such as file type association and locating"
LICENSE="LGPL-2 LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

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
	$(add_frameworks_dep kdoctools)
	test? ( dev-qt/qtconcurrent:5 )
"

# requires running kde environment
RESTRICT="test"
