# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="dockapp showing the load of every logical CPU on the system"
HOMEPAGE="https://bitbucket.org/StarFire/wmcpuwatch"
SRC_URI="https://bitbucket.org/StarFire/${PN}/downloads/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=x11-libs/libdockapp-0.7:="
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

DOCS=( ChangeLog README.md )
PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

src_prepare() {
	cmake-utils_src_prepare
	use doc || sed -e "s/add_subdirectory(doc)//" -i CMakeLists.txt || die
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc -r "${BUILD_DIR}"/doc/html
}
