# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_P="${PN}-dynamics-${P}"
DESCRIPTION="Integrated solution for real time simulation of physics environments"
HOMEPAGE="http://newtondynamics.com/forum/newton.php"
SRC_URI="https://github.com/MADEAPPS/newton-dynamics/archive/${P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/tinyxml"

src_prepare() {
	sed -i -e '/packages/d' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DNEWTON_DEMOS_SANDBOX=OFF
		-DCMAKE_VERBOSE_MAKEFILE=ON
	)
	cmake_src_configure
}
