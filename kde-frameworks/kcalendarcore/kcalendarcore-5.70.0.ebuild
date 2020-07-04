# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Library for interfacing with calendars"
LICENSE="GPL-2+ test? ( LGPL-3+ )"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE=""

BDEPEND="
	sys-devel/bison
"
DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	dev-libs/libical:=
"
RDEPEND="${DEPEND}
	!kde-apps/kcalcore:5
"

RESTRICT+=" test" # multiple tests fail or hang indefinitely
