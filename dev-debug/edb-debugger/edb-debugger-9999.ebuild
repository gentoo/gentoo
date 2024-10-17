# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Cross platform x86/x86-64 debugger, inspired by Ollydbg"
HOMEPAGE="https://github.com/eteran/edb-debugger"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/eteran/edb-debugger"
	inherit git-r3
else
	SRC_URI="https://github.com/eteran/edb-debugger/releases/download/${PV}/edb-debugger-${PV}.tgz"
	S="${WORKDIR}"/${PN}

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="graphviz"

RDEPEND="
	>=dev-libs/capstone-3.0:=
	dev-libs/double-conversion:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	graphviz? ( >=media-gfx/graphviz-2.38.0 )
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	if ! use graphviz; then
		sed -i -e '/pkg_check_modules(GRAPHVIZ/d' CMakeLists.txt || die
	fi

	cmake_src_prepare
}
