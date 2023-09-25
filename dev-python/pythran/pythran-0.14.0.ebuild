# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{10..11} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )

inherit distutils-r1 multiprocessing

MY_P=${P/_p/.post}
DESCRIPTION="Ahead of Time compiler for numeric kernels"
HOMEPAGE="
	https://pypi.org/project/pythran/
	https://github.com/serge-sans-paille/pythran/
"
SRC_URI="
	https://github.com/serge-sans-paille/pythran/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	dev-libs/boost
	=dev-python/beniget-0.4*[${PYTHON_USEDEP}]
	=dev-python/gast-0.5*[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/ply-3.4[${PYTHON_USEDEP}]
"
DEPEND="
	dev-libs/boost
	dev-cpp/xsimd
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/ipython[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		virtual/cblas
		!!dev-python/setuptools-declarative-requirements
	)
"

distutils_enable_tests pytest

src_configure() {
	cat >> setup.cfg <<-EOF
		[build_py]
		no_boost = True
		no_xsimd = True
	EOF
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		pythran/tests/test_xdoc.py::TestDoctest::test_cli
		pythran/tests/test_xdoc.py::TestDoctest::test_toolchain
		# Tries to invoke pip
		pythran/tests/test_distutils.py::TestDistutils::test_setup_build
		pythran/tests/test_distutils.py::TestDistutils::test_setup_build2
	)

	local -x COLUMNS=80
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p xdist -n "$(makeopts_jobs)"
}
