# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_6 python3_7 )

DESCRIPTION="Khronos OpenCL C++ bindings"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-CLHPP/"
SRC_URI="https://github.com/KhronosGroup/OpenCL-CLHPP/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Khronos-CLHPP"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

inherit python-any-r1 cmake-utils

DEPEND="virtual/opencl"
RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}"

src_unpack() {
	unpack ${A}
	# create symlink to change name
	ln -s OpenCL-CLHPP-${PV} ${P}
}

src_prepare() {
	# User patches + QA
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/include"
		-DBUILD_DOCS=OFF
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTS=OFF
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
