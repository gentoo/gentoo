# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
inherit python-any-r1 cmake

DESCRIPTION="Open Neural Network Exchange (ONNX)"
HOMEPAGE="https://github.com/onnx/onnx"
SRC_URI="https://github.com/onnx/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

DEPEND=""
RDEPEND="${DEPEND}
	dev-libs/protobuf:="
BDEPEND="
	${PYTHON_DEPS}
	dev-util/patchelf
"

src_configure() {
	local mycmakeargs=(
		-DONNX_USE_PROTOBUF_SHARED_LIBS=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	patchelf --set-soname libonnxifi.so "${ED}"/usr/lib/libonnxifi.so \
		|| die
	mv "${ED}"/usr/lib/libonnxifi.so "${ED}"/usr/$(get_libdir)/libonnxifi.so \
		|| die
}
