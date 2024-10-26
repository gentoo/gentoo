# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 cmake

DESCRIPTION="Open Neural Network Exchange (ONNX)"
HOMEPAGE="https://github.com/onnx/onnx"
SRC_URI="https://github.com/onnx/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="disableStaticReg"
RESTRICT="test"

RDEPEND="
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-libs/protobuf:=
	dev-cpp/abseil-cpp:=
"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply "${FILESDIR}"/${PN}-1.15.0-hidden.patch
	cmake_src_prepare
	distutils-r1_src_prepare
}

python_configure_all()
{
	mycmakeargs=(
		-DONNX_USE_PROTOBUF_SHARED_LIBS=ON
		-DONNX_USE_LITE_PROTO=ON
		-DONNX_BUILD_SHARED_LIBS=ON
		-DONNX_DISABLE_STATIC_REGISTRATION=$(usex disableStaticReg ON OFF)
	)
	cmake_src_configure
}

src_configure() {
	distutils-r1_src_configure
}

src_compile() {
	mycmakeargs=(
		-DONNX_USE_PROTOBUF_SHARED_LIBS=ON
		-DONNX_USE_LITE_PROTO=ON
		-DONNX_BUILD_SHARED_LIBS=ON
		-DONNX_DISABLE_STATIC_REGISTRATION=$(usex disableStaticReg ON OFF)
	)
	CMAKE_ARGS="${mycmakeargs[@]}" distutils-r1_src_compile
}

python_compile_all() {
	cmake_src_compile
}

python_install_all() {
	cmake_src_install
	distutils-r1_python_install_all
}

src_install() {
	distutils-r1_src_install
}
