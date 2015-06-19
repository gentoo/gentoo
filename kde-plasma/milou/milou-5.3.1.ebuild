# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/milou/milou-5.3.1.ebuild,v 1.1 2015/05/31 22:06:16 johu Exp $

EAPI=5

inherit kde5

DESCRIPTION="Dedicated search application built on top of Baloo"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/milou"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep krunner)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep plasma)
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	!kde-base/milou
"
