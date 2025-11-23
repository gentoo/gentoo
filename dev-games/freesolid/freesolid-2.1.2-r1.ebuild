# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P="FreeSOLID-${PV}"

DESCRIPTION="Library for collision detection of three-dimensional objects"
HOMEPAGE="https://sourceforge.net/projects/freesolid/"
SRC_URI="https://downloads.sourceforge.net/freesolid/${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

src_prepare() {
	sed -e 's/ \(-ffast-math -msse\|-mfpmath=sse\)//' \
		-e "/cmake_minimum_required/s/2\.8\.8/3\.10/" \
		-i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=no
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	doinfo doc/solid2.info
}
