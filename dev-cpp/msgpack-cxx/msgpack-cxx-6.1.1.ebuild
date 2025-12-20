# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="MessagePack for C++"
HOMEPAGE="https://msgpack.org/ https://github.com/msgpack/msgpack-c/"
SRC_URI="https://github.com/msgpack/msgpack-c/releases/download/cpp-${PV}/${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86 ~x64-macos"
IUSE="+boost doc examples test"

REQUIRED_USE="test? ( boost )"

RESTRICT="!test? ( test )"

RDEPEND="boost? ( dev-libs/boost[context] )
	!<dev-libs/msgpack-5.0.0"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen[dot] )
	test? ( virtual/zlib )"

src_configure() {
	local mycmakeargs=(
		-DMSGPACK_BUILD_EXAMPLES=OFF
		-DMSGPACK_CXX17=ON
		-DMSGPACK_BUILD_TESTS="$(usex test)"
		-DMSGPACK_USE_BOOST="$(usex boost)"
		-DMSGPACK_USE_X3_PARSE="$(usex boost)"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_build doxygen
	fi
}

src_install() {
	if use doc; then
		local HTML_DOCS=( "${BUILD_DIR}"/doc_cpp/html/. )
	fi

	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi

	cmake_src_install
}
