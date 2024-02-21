# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_OPTIONAL=1
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{9..12} )
inherit distutils-r1 cmake

DESCRIPTION="Open Neural Network Exchange (ONNX)"
HOMEPAGE="https://github.com/onnx/onnx"
SRC_URI="https://github.com/onnx/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="python"
RESTRICT="test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
	)
	dev-libs/protobuf:=
"
DEPEND="${RDEPEND}"

BDEPEND="python? (
	${DISTUTILS_DEPS}
)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.14.0-cxx_14.patch
	"${FILESDIR}"/${P}-musl.patch
)

src_prepare() {
	cmake_src_prepare
	use python && distutils-r1_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DONNX_USE_PROTOBUF_SHARED_LIBS=ON
		-DONNX_USE_LITE_PROTO=ON
	)
	cmake_src_configure
	use python && distutils-r1_src_configure
}

src_compile() {
	cmake_src_compile
	use python && CMAKE_ARGS="${mycmakeargs[@]}" distutils-r1_src_compile
}

src_install() {
	cmake_src_install
	use python && distutils-r1_src_install
}
