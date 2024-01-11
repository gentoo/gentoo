# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="dockapp showing the load of every logical CPU on the system"
HOMEPAGE="https://bitbucket-archive.softwareheritage.org/projects/st/StarFire/wmcpuwatch.html"
SRC_URI="https://bitbucket-archive.softwareheritage.org/static/83/8395d160-de4b-42d6-a7d9-939eade4f58a/attachments/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=x11-libs/libdockapp-0.7:="
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen[dot] )"

DOCS=( ChangeLog README.md )
PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

src_prepare() {
	cmake_src_prepare
	use doc || sed -e "s/add_subdirectory(doc)//" -i CMakeLists.txt || die
}

src_install() {
	cmake_src_install
	use doc && dodoc -r "${BUILD_DIR}"/doc/html
}
