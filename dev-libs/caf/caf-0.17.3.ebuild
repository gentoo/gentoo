# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake-multilib python-single-r1

DESCRIPTION="The C++ Actor Framework (CAF)"
HOMEPAGE="https://actor-framework.org/"
SRC_URI="https://github.com/actor-framework/actor-framework/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( Boost-1.0 BSD )"
SLOT="0/17.3"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples opencl +openssl python static-libs test tools"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="examples? ( net-misc/curl[${MULTILIB_USEDEP}] )
	openssl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP},static-libs?] )
	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )
	python? ( ${PYTHON_DEPS}
		dev-python/ipython
		dev-python/pybind11[${PYTHON_USEDEP}] )"

DEPEND="${RDEPEND}"

BDEPEND="doc? ( app-doc/doxygen[dot]
	app-shells/bash:0
	dev-texlive/texlive-fontsextra
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra )"

RESTRICT="!test? ( test )"

src_unpack() {
	default
	mv * "${P}" || die
}

src_prepare() {
	append-cflags "-std=c++11 -Wextra -Wall -pedantic"
	append-cxxflags "-std=c++11 -Wextra -Wall -pedantic"

	rm -rf libcaf_python/third_party || die

	if use python; then
		sed -i 's:.*/third_party/pybind/.*:if(FALSE):' \
			libcaf_python/CMakeLists.txt || die
		sed -i 's:.*pybind11/pybind11.h"$:#include "pybind11/pybind11.h":' \
			libcaf_python/src/main.cpp || die
	fi

	cmake_src_prepare
}

multilib_src_configure() {
	if multilib_is_native_abi && use python; then
		local no_python=no
	else
		local no_python=yes
	fi
	local mycmakeargs=(
		-DCAF_BUILD_STATIC=$(usex static-libs)
		-DCAF_BUILD_TEX_MANUAL=$(usex doc)
		-DCAF_ENABLE_ADDRESS_SANITIZER=$(usex debug)
		-DCAF_ENABLE_RUNTIME_CHECKS=$(usex debug)
		-DCAF_LOG_LEVEL=$(usex debug DEBUG QUIET)
		-DCAF_NO_EXAMPLES=$(usex examples no yes)
		-DCAF_NO_OPENCL=$(usex opencl no yes)
		-DCAF_NO_OPENSSL=$(usex openssl no yes)
		-DCAF_NO_PYTHON=${no_python}
		-DCAF_NO_TOOLS=$(usex tools no yes)
		-DCAF_NO_UNIT_TESTS=$(usex test no yes)
		-DCMAKE_SKIP_RPATH=yes
		-DLIBRARY_OUTPUT_PATH="$(get_libdir)"
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	use doc && cmake_src_make doxygen manual
}

multilib_src_test() {
	if multilib_is_native_abi; then
		local libdir="$(get_libdir)"
		local libs="${BUILD_DIR}/libcaf_core/${libdir}"
		libs="${libs}:${BUILD_DIR}/libcaf_io/${libdir}"

		use opencl && libs="${libs}:${BUILD_DIR}/libcaf_opencl/${libdir}"
		use openssl && libs="${libs}:${BUILD_DIR}/libcaf_openssl/${libdir}"
		use python && libs="${libs}:${BUILD_DIR}/libcaf_python/${libdir}"

		einfo "LD_LIBRARY_PATH is set to ${libs}"
		LD_LIBRARY_PATH="${libs}" cmake_src_test
	fi
}

multilib_src_install() {
	cmake_src_install

	if multilib_is_native_abi; then
		dobin bin/*
		if use doc ; then
			dodoc -r "${BUILD_DIR}"/doc/pdf
			dodoc -r "${BUILD_DIR}"/doc/html
			docinto pdf
			dodoc "${BUILD_DIR}"/doc/manual.pdf
		fi
	fi
}
