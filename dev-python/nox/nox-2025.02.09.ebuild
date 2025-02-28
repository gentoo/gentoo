# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Flexible test automation for Python"
HOMEPAGE="
	https://github.com/wntrblm/nox/
	https://pypi.org/project/nox/
"
SRC_URI="
	https://github.com/wntrblm/nox/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/argcomplete-1.9.4[${PYTHON_USEDEP}]
	>=dev-python/attrs-23.1[${PYTHON_USEDEP}]
	>=dev-python/colorlog-2.6.1[${PYTHON_USEDEP}]
	>=dev-python/dependency-groups-1.1[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.9[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.14.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		dev-python/py[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# remove upper bounds from dependencies
	sed -i -e 's:<[0-9.]*,::' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO: conda?
		'tests/test_sessions.py::TestSessionRunner::test__create_venv_options[nox.virtualenv.CondaEnv.create-conda-CondaEnv]'
		# Internet
		tests/test_virtualenv.py::test_uv_install
		tests/test_main.py::test_noxfile_script_mode
	)

	case ${EPYTHON} in
		pypy3*)
			EPYTEST_DESELECT+=(
				# hardcoded CPython assumption
				tests/test_tox_to_nox.py::test_commands_with_requirements
				tests/test_tox_to_nox.py::test_skipinstall
				tests/test_tox_to_nox.py::test_trivial
				tests/test_tox_to_nox.py::test_usedevelop
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o tmp_path_retention_policy=all
}
