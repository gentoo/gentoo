# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Library for handling calendar data"
LICENSE="GPL-2+ test? ( LGPL-3+ )"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_qt_dep qtgui)
	dev-libs/libical:=
"
DEPEND="${RDEPEND}
	sys-devel/bison
"

RESTRICT+=" test" # multiple tests fail or hang indefinitely
