# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="edb is a cross platform x86/x86-64 debugger, inspired by Ollydbg"
HOMEPAGE="https://github.com/eteran/edb-debugger"
SRC_URI="https://github.com/eteran/edb-debugger/releases/download/${PV}/edb-debugger-${PV}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="graphviz"

S="${WORKDIR}/${P}"

RDEPEND="
	dev-libs/capstone
	graphviz? ( media-gfx/graphviz )
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtnetwork:5
	dev-qt/qtconcurrent:5
	dev-qt/qtgui:5
	dev-qt/qtcore:5
"

DEPEND="
	dev-libs/boost
	virtual/pkgconfig
	${RDEPEND}
"

src_prepare(){
	#Make the desktop's entries somewhat better
	sed -i -e 's/GenericName=edb debugger/GenericName=Evan\x27s Debugger/' edb.desktop || die
	sed -i -e 's/Comment=edb debugger/Comment=edb is a cross platform x86\/x86-64 debugger/' edb.desktop || die

	cmake-utils_src_prepare
}

src_configure(){
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_GRAPHVIZ=$(usex !graphviz)
	)
	cmake-utils_src_configure
}
