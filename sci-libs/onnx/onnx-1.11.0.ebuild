# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

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
	dev-libs/protobuf"
BDEPEND="dev-util/patchelf"

src_install() {
	cmake_src_install

	patchelf --set-soname libonnxifi.so "${D}"/usr/lib/libonnxifi.so \
		|| die
	mv "${D}"/usr/lib/libonnxifi.so "${D}"/usr/$(get_libdir)/libonnxifi.so \
		|| die
}
