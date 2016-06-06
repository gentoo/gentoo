# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs cmake-utils unpacker

MY_P="${PN}-dynamics-${P}"
DESCRIPTION="an integrated solution for real time simulation of physics environments"
HOMEPAGE="http://newtondynamics.com/forum/newton.php"
SRC_URI="https://github.com/MADEAPPS/newton-dynamics/archive/${P}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="$(unpacker_src_uri_depends)"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e '/packages/d' CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr/
		-DNEWTON_DEMOS_SANDBOX=OFF
		-DCMAKE_VERBOSE_MAKEFILE=ON
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_install
}
