# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib git-r3

DESCRIPTION="A JSON implementation in C"
HOMEPAGE="https://github.com/json-c/json-c/wiki"
EGIT_REPO_URI="https://github.com/json-c/json-c.git"

LICENSE="MIT"
SLOT="0/5"
IUSE="cpu_flags_x86_rdrand doc static-libs threads"

BDEPEND="doc? ( >=app-doc/doxygen-1.8.13 )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/json-c/config.h
)

src_prepare() {
	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DDISABLE_WERROR=ON
		-DDISABLE_EXTRA_LIBS=ON
		-DENABLE_THREADING=$(usex threads)
		-DENABLE_RDRAND=$(usex cpu_flags_x86_rdrand)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
	use doc && doxygen doc/Doxyfile
}

multilib_src_test() {
	multilib_is_native_abi && cmake_src_test
}

multilib_src_install_all() {
	use doc && HTML_DOCS=( "${BUILD_DIR}-abi_x86_64.amd64"/doc/html/. )
	einstalldocs
}
