# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="edb is a cross platform x86/x86-64 debugger, inspired by Ollydbg"
HOMEPAGE="https://github.com/eteran/edb-debugger"

LICENSE="GPL-2+"
IUSE="debug graphviz"
SLOT="0"
EGIT_REPO_URI="https://github.com/eteran/edb-debugger.git"
KEYWORDS=""

RDEPEND="
	>=dev-libs/capstone-3.0
	graphviz? ( >=media-gfx/graphviz-2.38.0 )
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtnetwork:5
	dev-qt/qtconcurrent:5
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	"
DEPEND="
	>=dev-libs/boost-1.35.0
	virtual/pkgconfig
	${RDEPEND}"

src_prepare(){
	#Make the desktop's entries somewhat cuter
	sed -i -e 's/GenericName=edb debugger/GenericName=Evan\x27s Debugger/' edb.desktop || die
	sed -i -e 's/Comment=edb debugger/Comment=edb is a cross platform x86\/x86-64 debugger/' edb.desktop || die

	if ! use graphviz; then
		sed -i '/pkg_check_modules(GRAPHVIZ/d' CMakeLists.txt || die
	fi
	cmake-utils_src_prepare
}

src_configure() {
	CMAKE_BUILD_TYPE=Release
	use debug && CMAKE_BUILD_TYPE=Debug

	mycmakeargs+=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DQT_VERSION=Qt5
	)

	cmake-utils_src_configure
}
