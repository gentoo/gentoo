# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="OpenCL-CLHPP"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Khronos OpenCL C++ bindings"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-CLHPP/"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Khronos-CLHPP"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="test"

# Tests require CMock (NOT cmocka), which is currently not in Gentoo
# and has been found to be extremely awkward to package.
# Should it ever get packaged, consult git history for how to set things up
# for the clhpp test suite.
RESTRICT="test"

RDEPEND="virtual/opencl"
DEPEND="${RDEPEND}
	>=dev-util/opencl-headers-${PV}"

S="${WORKDIR}"/${MY_P}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=OFF
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
