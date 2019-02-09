# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
inherit kde5

DESCRIPTION="Library for parsing RSS and Atom feeds"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	test? (
		$(add_qt_dep qtnetwork)
		$(add_qt_dep qtwidgets)
	)
"
DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_qt_dep qtxml)
"
RDEPEND="${DEPEND}
	!kde-apps/syndication
"
