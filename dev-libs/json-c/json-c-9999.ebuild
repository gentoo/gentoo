# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CMAKE_ECLASS=cmake
inherit cmake-multilib git-r3

DESCRIPTION="A JSON implementation in C"
HOMEPAGE="https://github.com/json-c/json-c/wiki"
EGIT_REPO_URI="https://github.com/json-c/json-c.git"

LICENSE="MIT"
SLOT="0/5"
IUSE="doc static-libs threads"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/json-c/config.h
)

src_prepare() {
	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(multilib_native_usex doc)
		-DDISABLE_WERROR=ON
		-DENABLE_THREADING=$(usex threads)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
}

multilib_src_test() {
	multilib_is_native_abi && cmake_src_test
}

multilib_src_install_all() {
	use doc && HTML_DOCS=( "${S}"/doc/html/. )
	einstalldocs
}
