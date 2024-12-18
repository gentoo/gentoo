# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_TESTED=( python3_{10..13} pypy3 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_13t )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="A simple, correct PEP517 package builder"
HOMEPAGE="
	https://pypi.org/project/build/
	https://github.com/pypa/build/
"
SRC_URI="
	https://github.com/pypa/build/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test-rust"

RDEPEND="
	>=dev-python/packaging-19.1[${PYTHON_USEDEP}]
	dev-python/pyproject-hooks[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			>=dev-python/filelock-3[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-2[${PYTHON_USEDEP}]
			>=dev-python/pytest-rerunfailures-9.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-xdist-1.34[${PYTHON_USEDEP}]
			>=dev-python/setuptools-56.0.0[${PYTHON_USEDEP}]
			>=dev-python/virtualenv-20.0.35[${PYTHON_USEDEP}]
			>=dev-python/wheel-0.36.0[${PYTHON_USEDEP}]
			test-rust? (
				!s390? ( !sparc? ( dev-python/uv ) )
			)
		' "${PYTHON_TESTED[@]}")
	)
"

distutils_enable_tests pytest

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local EPYTEST_DESELECT=(
		# broken by the presence of flit_core
		tests/test_util.py::test_wheel_metadata_isolation
		# broken by the presence of virtualenv (it changes the error
		# messages, sic!)
		'tests/test_main.py::test_output[via-sdist-isolation]'
		'tests/test_main.py::test_output[wheel-direct-isolation]'
		# broken when built in not normal tty on coloring
		tests/test_main.py::test_colors
		'tests/test_main.py::test_output_env_subprocess_error[color]'
		# Internet
		'tests/test_main.py::test_verbose_output[False-0]'
		'tests/test_main.py::test_verbose_output[False-1]'
		# broken by uv being installed outside venv
		tests/test_env.py::test_external_uv_detection_success
		# broken by unbundled pip (TODO: fix pip eventually)
		'tests/test_projectbuilder.py::test_build_with_dep_on_console_script[False]'
	)

	if ! has_version "dev-python/uv"; then
		EPYTEST_DESELECT+=(
			tests/test_env.py::test_uv_impl_install_cmd_well_formed
			'tests/test_env.py::test_venv_creation[uv-venv+uv-None]'
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_XDIST=1
	epytest -m "not network" -p pytest_mock -p rerunfailures
}
