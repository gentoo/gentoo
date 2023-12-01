# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_PN="${PN}-c"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="https://msgpack.org/ https://github.com/msgpack/msgpack-c/"
SRC_URI="https://github.com/${PN}/${PN}-c/releases/download/c-${PV}/${MY_P}.tar.gz"

LICENSE="Boost-1.0"
# Need the -c as a one-off (can drop on next soname bump) as the library rename
# from libmsgpackc.so.2 -> libmsgpack-c.so.2 is effectively an ABI break and
# has all the same problems a new SONAME would have.
# See https://github.com/msgpack/msgpack-c/pull/1053.
SLOT="0/2-c"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc examples test"

RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen[dot] )
	test? (
		dev-cpp/gtest[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)"

S="${WORKDIR}"/${MY_P}

multilib_src_configure() {
	local mycmakeargs=(
		-DMSGPACK_BUILD_EXAMPLES=OFF
		-DMSGPACK_BUILD_TESTS="$(usex test)"
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	if multilib_is_native_abi && use doc; then
		cmake_build doxygen
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		if use doc; then
			local HTML_DOCS=( "${BUILD_DIR}"/doc_c/html/. )
		fi

		if use examples; then
			docinto examples
			dodoc -r "${S}"/example/.
			docompress -x /usr/share/doc/${PF}/examples
		fi
	fi

	cmake_src_install
}
