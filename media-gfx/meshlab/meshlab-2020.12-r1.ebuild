# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="A system for processing and editing unstructured 3D triangular meshes"
HOMEPAGE="http://www.meshlab.net"
VCG_VERSION="2020.12"
SRC_URI="https://github.com/cnr-isti-vclab/meshlab/archive/Meshlab-${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/cnr-isti-vclab/vcglib/archive/${VCG_VERSION}.tar.gz -> vcglib-${VCG_VERSION}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="double-precision -minimal"

DEPEND="
	dev-cpp/eigen:3
	dev-cpp/muParser
	dev-libs/gmp:=
	>=dev-qt/qtcore-5.12:5
	>=dev-qt/qtdeclarative-5.12:5
	>=dev-qt/qtopengl-5.12:5
	>=dev-qt/qtscript-5.12:5
	>=dev-qt/qtxml-5.12:5
	>=dev-qt/qtxmlpatterns-5.12:5
	media-libs/glew:0=
	=media-libs/lib3ds-1*
	media-libs/openctm:=
	media-libs/qhull:=
	sci-libs/levmar
	sci-libs/mpir:="

RDEPEND="${DEPEND}"

S="${WORKDIR}/meshlab-Meshlab-${PV}/src"

PATCHES=(
	"${FILESDIR}/${P}-disable-updates.patch"
	"${FILESDIR}/${P}-find-plugins.patch"
)

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	unpack vcglib-2020.12.tar.gz
	mv vcglib-2020.12/* vcglib
}

src_configure() {
	CMAKE_BUILD_TYPE=Release

	local mycmakeargs=(
		-DBUILD_MINI=$(usex minimal)
		-DBUILD_WITH_DOUBLE_SCALAR=$(usex double-precision)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}
