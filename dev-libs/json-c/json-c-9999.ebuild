# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib git-r3 multibuild

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

multilib_src_configure() {
	local mycmakeargs=(
		# apps are not installed, so disable unconditionally.
		# https://github.com/json-c/json-c/blob/json-c-0.17-20230812/apps/CMakeLists.txt#L119...L121
		-DBUILD_APPS=OFF
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DDISABLE_EXTRA_LIBS=ON
		-DDISABLE_WERROR=ON
		-DENABLE_RDRAND=$(usex cpu_flags_x86_rdrand)
		-DENABLE_THREADING=$(usex threads)
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
	if use doc && multilib_is_native_abi; then
		cmake_build doc
	fi
}

multilib_src_test() {
	multilib_is_native_abi && cmake_src_test
}

multilib_src_install() {
	if multilib_is_native_abi; then
		use doc && HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
		einstalldocs
	fi
}
