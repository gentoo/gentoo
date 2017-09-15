# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-multilib

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}-c.git"
else
	SRC_URI="https://github.com/${PN}/${PN}-c/releases/download/cpp-${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
fi

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="http://msgpack.org/ https://github.com/msgpack/msgpack-c/"

LICENSE="Boost-1.0"
SLOT="0"
IUSE="+cxx doc examples static-libs test"

DEPEND="
	test? (
		>=dev-cpp/gtest-1.6.0-r2[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
	doc? ( app-doc/doxygen[dot] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.2-cflags.patch
	"${FILESDIR}"/${PN}-1.4.2-static.patch
)

src_configure() {
	local mycmakeargs=(
		-DMSGPACK_ENABLE_CXX="$(usex cxx)"
		-DMSGPACK_STATIC="$(usex static-libs)"
		-DMSGPACK_BUILD_TESTS="$(usex test)"
		# Don't build the examples
		-DMSGPACK_BUILD_EXAMPLES=OFF
		# Enable C++11 by default
		-DMSGPACK_CXX11=ON
	)
	cmake-multilib_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile

	if multilib_is_native_abi && use doc; then
		cmake-utils_src_make doxygen
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		if use doc; then
			local HTML_DOCS=( "${BUILD_DIR}"/docs/. )

			mkdir docs || die
			mv doc_c/html docs/c || die

			use cxx && mv doc_cpp/html docs/cpp || die
		fi

		if use examples; then
			docinto examples

			dodoc -r "${WORKDIR}/${P}/example/."

			docompress -x /usr/share/doc/${PF}/examples
		fi
	fi

	cmake-utils_src_install
}
