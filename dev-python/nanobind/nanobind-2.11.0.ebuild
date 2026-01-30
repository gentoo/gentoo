# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( python3_{11..14} )

inherit cmake distutils-r1

DESCRIPTION="Tiny and efficient C++/Python bindings"
HOMEPAGE="
	https://github.com/wjakob/nanobind/
	https://pypi.org/project/nanobind/
"
SRC_URI="
	https://github.com/wjakob/nanobind/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-cpp/robin-map-1.3.0
"
RDEPEND="
	${DEPEND}
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	cmake_src_prepare
	distutils-r1_src_prepare
}

src_configure() {
	# XXX: nanobind installs a CMake config file which by default passes -Os
	# We currently patch around it in dev-python/pyopencl. In future, we
	# may want to add some override with Gentoo specific environment vars.
	DISTUTILS_ARGS=(
		-DNB_CREATE_INSTALL_RULES=ON
		-DNB_USE_SUBMODULE_DEPS=OFF
		-DNB_TEST=OFF
	)
}

python_test() {
	local mycmakeargs=(
		-DNB_CREATE_INSTALL_RULES=OFF
		-DNB_USE_SUBMODULE_DEPS=OFF
		-DNB_TEST=ON
	)
	cmake_src_configure
	cmake_src_compile

	cd "${BUILD_DIR}/tests" || die
	epytest
}
