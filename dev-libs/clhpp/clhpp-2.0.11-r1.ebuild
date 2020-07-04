# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Khronos OpenCL C++ bindings"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-CLHPP/"
SRC_URI="https://github.com/KhronosGroup/OpenCL-CLHPP/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Khronos-CLHPP"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="virtual/opencl"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/OpenCL-CLHPP-${PV}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=OFF
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTS=OFF
	)
	cmake_src_configure
}
