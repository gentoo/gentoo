# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_P="FreeSOLID-${PV}"

DESCRIPTION="Library for collision detection of three-dimensional objects"
HOMEPAGE="https://sourceforge.net/projects/freesolid/"
SRC_URI="mirror://sourceforge/freesolid/${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

src_prepare() {
	cmake_src_prepare

	sed -i 's/ \(-ffast-math -msse\|-mfpmath=sse\)//' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=( -DBUILD_SHARED_LIBS=no )

	cmake_src_configure
}

src_install() {
	cmake_src_install

	doinfo doc/solid2.info
}
