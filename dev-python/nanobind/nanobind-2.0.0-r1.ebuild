# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit cmake distutils-r1

DESCRIPTION="Tiny and efficient C++/Python bindings"
HOMEPAGE="
	https://github.com/wjakob/nanobind
	https://pypi.org/project/nanobind/
"
SRC_URI="
	https://github.com/wjakob/nanobind/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv"

RDEPEND=">=dev-cpp/robin-map-1.3.0"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.10)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_prepare_all() {
	# This test assumes in-source build for the .pyi stubs.
	# (Hack because EPYTEST_IGNORE doesn't work with the paths it collects(?))
	echo > tests/test_stubs.py || die

	cmake_src_prepare
	distutils-r1_python_prepare_all
}

python_configure() {
	# XXX: nanobind installs a CMake config file which by default passes -Os
	# We currently patch around it in dev-python/pyopencl. In future, we
	# may want to add some override with Gentoo specific environment vars.
	local mycmakeargs=(
		-DNB_CREATE_INSTALL_RULES=ON
		-DNB_USE_SUBMODULE_DEPS=OFF
		-DNB_TEST=$(usex test)
	)
	cmake_src_configure
}

python_compile() {
	distutils-r1_python_compile
	cmake_src_compile
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	cd "${BUILD_DIR}/tests" || die
	epytest "${S}/tests"
}

python_install() {
	distutils-r1_python_install
	cmake_src_install
}
