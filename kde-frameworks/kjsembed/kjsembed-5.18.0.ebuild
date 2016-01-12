# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework binding JavaScript objects to QObjects"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kjs)
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kdoctools)
	dev-qt/designer:5
"
