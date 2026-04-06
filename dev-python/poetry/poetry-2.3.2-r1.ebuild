# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYPI_VERIFY_REPO=https://github.com/python-poetry/poetry
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="A frontend for poetry - a python dependency management and packaging tool"
HOMEPAGE="
	https://python-poetry.org/
	https://github.com/python-poetry/poetry/
	https://pypi.org/project/poetry/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	=dev-python/poetry-core-$(ver_cut 1-2)*[${PYTHON_USEDEP}]
	>=dev-python/poetry-plugin-export-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/build-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/cachecontrol-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/cleo-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.25.0[${PYTHON_USEDEP}]
	>=dev-python/fastjsonschema-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/findpython-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/installer-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/keyring-25.1.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.2[${PYTHON_USEDEP}]
	>=dev-python/pbs-installer-2025.06.10[${PYTHON_USEDEP}]
	>=dev-python/pkginfo-1.12[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/shellingham-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.11.6[${PYTHON_USEDEP}]
	>=dev-python/trove-classifiers-2022.5.19[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.26.6[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/deepdiff-6.3.1[${PYTHON_USEDEP}]
		>=dev-python/jaraco-classes-3.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.9[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-mock )
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internal test for lockfile being up-to-date
	# Meaningless, also sdist does not include lockfile
	tests/installation/test_installer.py::test_not_fresh_lock

	# broken if poetry-plugin-export is installed
	'tests/console/test_application_command_not_found.py::test_application_command_not_found_messages[x-None]'
)

src_prepare() {
	# unpin
	sed -e 's:,<[0-9.]*::' -e 's:==\([0-9]\):>=\1:' -i pyproject.toml || die

	distutils-r1_src_prepare
}

python_test() {
	epytest -m "not network"
}
