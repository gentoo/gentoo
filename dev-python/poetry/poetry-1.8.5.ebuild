# Copyright 2023-2024 Gentoo Authors
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
	>=dev-python/poetry-core-1.9.1[${PYTHON_USEDEP}]
	>=dev-python/poetry-plugin-export-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/build-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/cachecontrol-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/cleo-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/crashtest-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.21.2[${PYTHON_USEDEP}]
	>=dev-python/fastjsonschema-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/installer-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/keyring-24.0.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.7.0[${PYTHON_USEDEP}]
	>=dev-python/pkginfo-1.12[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/shellingham-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.11.6[${PYTHON_USEDEP}]
	>=dev-python/trove-classifiers-2022.5.19[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.0[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.26.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	' 3.10)
"

BDEPEND="
	test? (
		>=dev-python/deepdiff-6.3.1[${PYTHON_USEDEP}]
		>=dev-python/httpretty-1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.9[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# unpin
	sed -e 's:\^:>=:' \
		-e '/poetry-core/s:":">=:' \
		-e 's:,<[0-9.]*::' \
		-i pyproject.toml || die

	distutils-r1_src_prepare
}

EPYTEST_DESELECT=(
	# Internal test for lockfile being up-to-date
	# Meaningless, also sdist does not include lockfile
	tests/installation/test_installer.py::test_not_fresh_lock

	# TODO
	tests/installation/test_executor.py::test_executor_known_hashes
	tests/utils/env/test_env_manager.py::test_create_venv_finds_no_python_executable
)

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -m "not network" -p pytest_mock
}
