# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="osgQt"
MY_P=${MY_PN}-${PV}
inherit cmake

DESCRIPTION="Qt support for OpenSceneGraph"
HOMEPAGE="http://www.openscenegraph.org/"
SRC_URI="https://github.com/openscenegraph/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="wxWinLL-3 LGPL-2.1"
SLOT="0/145" # NOTE: CHECK WHEN BUMPING! Subslot is SOVERSION
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="examples webkit"

RDEPEND="
	>=dev-games/openscenegraph-3.6.3:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	webkit? ( dev-qt/qtwebkit:5 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.5.5-cmake.patch
	"${FILESDIR}"/${PN}-3.5.5-qt-5.11b3.patch
)

src_configure() {
	local mycmakeargs=(
		-DDYNAMIC_OPENSCENEGRAPH=ON
		-DDESIRED_QT_VERSION=5
		-DBUILD_OSG_EXAMPLES=$(usex examples)
		$(cmake_use_find_package webkit Qt5WebKitWidgets)
	)

	cmake_src_configure
}
