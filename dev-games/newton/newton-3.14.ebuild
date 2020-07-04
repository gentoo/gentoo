# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils toolchain-funcs

MY_P="${PN}-dynamics-${P}"
DESCRIPTION="Integrated solution for real time simulation of physics environments"
HOMEPAGE="http://newtondynamics.com/forum/newton.php"
SRC_URI="https://github.com/MADEAPPS/newton-dynamics/archive/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="dev-libs/tinyxml"

S=${WORKDIR}/${MY_P}

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e '/packages/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DNEWTON_DEMOS_SANDBOX=OFF
		-DCMAKE_VERBOSE_MAKEFILE=ON
	)
	cmake-utils_src_configure
}
