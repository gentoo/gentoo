# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils
DESCRIPTION="Qt support for OpenSceneGraph"
HOMEPAGE="http://www.openscenegraph.org/"
SRC_URI="https://github.com/openscenegraph/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="wxWinLL-3 LGPL-2.1"
SLOT="0/35" # Subslot consists of major + minor version number
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples qt5"

RDEPEND="
	dev-games/openscenegraph:${SLOT}
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DDYNAMIC_OPENSCENEGRAPH=ON
		-DDESIRED_QT_VERSION=5
		-DGENTOO_DOCDIR="/usr/share/doc/${PF}"
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_OSG_EXAMPLES=$(usex examples)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc_openscenegraph doc_openthreads
}
