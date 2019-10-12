# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Library for interfacing with calendars"
LICENSE="GPL-2+ test? ( LGPL-3+ )"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

BDEPEND="
	sys-devel/bison
"
DEPEND="
	$(add_qt_dep qtgui)
	dev-libs/libical:=
"
RDEPEND="${DEPEND}
	!kde-apps/kcalcore:5
"

RESTRICT+=" test" # multiple tests fail or hang indefinitely
