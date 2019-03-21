# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
inherit kde5

DESCRIPTION="Library for parsing RSS and Atom feeds"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_qt_dep qtxml)
"
DEPEND="${COMMON_DEPEND}
	test? (
		$(add_qt_dep qtnetwork)
		$(add_qt_dep qtwidgets)
	)
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/syndication
"
