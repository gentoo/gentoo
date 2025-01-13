# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A frontend for poetry - a python dependency management and packaging tool"
HOMEPAGE="
	https://python-poetry.org/
	https://github.com/python-poetry/poetry
	https://pypi.org/project/poetry/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/poetry-core-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/poetry-plugin-export-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/build-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/cachecontrol-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/cleo-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.22.6[${PYTHON_USEDEP}]
	>=dev-python/fastjsonschema-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/installer-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/keyring-25.1.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
	>=dev-python/pkginfo-1.12[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/shellingham-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.11.6[${PYTHON_USEDEP}]
	>=dev-python/trove-classifiers-2022.5.19[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.26.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	' 3.10)
"

BDEPEND="
	test? (
		>=dev-python/deepdiff-6.3.1[${PYTHON_USEDEP}]
		>=dev-python/httpretty-1.1[${PYTHON_USEDEP}]
		>=dev-python/jaraco-classes-3.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.9[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# unpin
	sed -e 's:,<[0-9.]*::' -e 's:==\([0-9]\):>=\1:' -i pyproject.toml || die

	distutils-r1_src_prepare
}

EPYTEST_DESELECT=(
	# Internal test for lockfile being up-to-date
	# Meaningless, also sdist does not include lockfile
	tests/installation/test_installer.py::test_not_fresh_lock

	# TODO
	tests/installation/test_executor.py::test_executor_known_hashes
	tests/puzzle/test_provider.py::test_search_for_directory_setup_read_setup_with_no_dependencies
	tests/utils/env/test_env_manager.py::test_create_venv_finds_no_python_executable
	tests/utils/test_python_manager.py::test_python_get_preferred_default
	'tests/inspection/test_info.py::test_info_setup_missing_mandatory_should_trigger_pep517[name]'
)

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -m "not network" -p pytest_mock
}
