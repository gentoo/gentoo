# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="edb is a cross platform x86/x86-64 debugger, inspired by Ollydbg"
HOMEPAGE="https://github.com/eteran/edb-debugger"
EGIT_REPO_URI="https://github.com/eteran/edb-debugger.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="graphviz"

RDEPEND="
	dev-libs/capstone
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	graphviz? ( media-gfx/graphviz )
"

DEPEND="
	dev-libs/boost
	virtual/pkgconfig
	${RDEPEND}
"

src_prepare() {
	if ! use graphviz; then
		sed -i -e '/pkg_check_modules(GRAPHVIZ/d' CMakeLists.txt || die
	fi
	cmake-utils_src_prepare
}
