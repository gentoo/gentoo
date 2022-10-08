# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm frameworks.kde.org

DESCRIPTION="Library for interfacing with calendars"
LICENSE="GPL-2+ test? ( LGPL-3+ )"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RESTRICT="test" # multiple tests fail or hang indefinitely

DEPEND="
	>=dev-libs/libical-3.0.5:=
	>=dev-qt/qtgui-${QTMIN}:5
"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/bison"
