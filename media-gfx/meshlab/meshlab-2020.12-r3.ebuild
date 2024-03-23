# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VCG_VERSION="2020.12"
inherit cmake xdg

DESCRIPTION="System for processing and editing unstructured 3D triangular meshes"
HOMEPAGE="https://www.meshlab.net/"
SRC_URI="https://github.com/cnr-isti-vclab/meshlab/archive/Meshlab-${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/cnr-isti-vclab/vcglib/archive/${VCG_VERSION}.tar.gz -> vcglib-${VCG_VERSION}.tar.gz"
S="${WORKDIR}/meshlab-Meshlab-${PV}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="double-precision minimal"

# qhull: newer meshlab supports system re-entrant version
# levmar: build system hardcodes vendored copy
DEPEND="
	dev-cpp/eigen:3
	dev-cpp/muParser
	dev-libs/gmp:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/glew:0=
	=media-libs/lib3ds-1*
	media-libs/openctm:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-disable-updates.patch"
	"${FILESDIR}/${P}-find-plugins.patch"
)

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}" || die
	unpack vcglib-2020.12.tar.gz
	mv vcglib-2020.12/* vcglib || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_MINI=$(usex minimal)
		-DBUILD_WITH_DOUBLE_SCALAR=$(usex double-precision)
	)
	cmake_src_configure
}
