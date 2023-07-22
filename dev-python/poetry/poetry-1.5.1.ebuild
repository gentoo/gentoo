# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="A frontend for poetry - a python dependency management and packaging tool"
HOMEPAGE="
	https://python-poetry.org/
	https://github.com/python-poetry/poetry
	https://pypi.org/project/poetry/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/poetry-core-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/poetry-plugin-export-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/build-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/cleo-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/crashtest-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.21.2[${PYTHON_USEDEP}]
	>=dev-python/installer-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.10.0[${PYTHON_USEDEP}]
	>=dev-python/keyring-23.9.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.4[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.7.0[${PYTHON_USEDEP}]
	>=dev-python/pkginfo-1.9.4[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.18[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/shellingham-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.11.6[${PYTHON_USEDEP}]
	>=dev-python/trove-classifiers-2022.5.19[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.22.0[${PYTHON_USEDEP}]
	>=dev-python/cachecontrol-0.12.9[${PYTHON_USEDEP}]
"

DEPEND="
	test? (
			>=dev-python/deepdiff-6.3.1[${PYTHON_USEDEP}]
			>=dev-python/httpretty-1.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-3.9[${PYTHON_USEDEP}]
			>=dev-python/pytest-xdist-3.1[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# Dependency on abandoned package cachy has been removed from poetry https://github.com/python-poetry/poetry/pull/5868
	# and remains in tests only for time being, so we can skip them.
	# removal of tests upstream https://github.com/python-poetry/poetry/pull/7437
	sed -e "s/from cachy import CacheManager/from unittest import mock; CacheManager = mock.Mock # Gentoo ebuild patched/g" \
		-i tests/console/commands/cache/conftest.py \
		-i tests/utils/test_cache.py || die
	sed -e 's:"cachy_file_cache", ::g' \
		-i tests/utils/test_cache.py || die

	distutils-r1_src_prepare
}

EPYTEST_DESELECT=(
	# Dependency on abandoned package cachy has been removed from poetry https://github.com/python-poetry/poetry/pull/5868
	# and remains in tests only for time being, so we can skip them.
	# removal of tests upstream https://github.com/python-poetry/poetry/pull/7437
	tests/console/commands/cache/test_clear.py::test_cache_clear_all
	tests/console/commands/cache/test_clear.py::test_cache_clear_all_no
	tests/console/commands/cache/test_clear.py::test_cache_clear_pkg
	tests/console/commands/cache/test_clear.py::test_cache_clear_pkg_no
	tests/utils/test_cache.py::test_cachy_compatibility

	# Tests require network (they run `pip install ...`)
	tests/installation/test_executor.py::test_executor_should_write_pep610_url_references_for_directories
	tests/installation/test_executor.py::test_executor_should_write_pep610_url_references_for_git
	tests/installation/test_executor.py::test_executor_should_write_pep610_url_references_for_git_with_subdirectories
	tests/installation/test_pip_installer.py::test_uninstall_git_package_nspkg_pth_cleanup
	tests/installation/test_executor.py::test_executor_should_write_pep610_url_references_for_non_wheel_files
	tests/installation/test_installer.py::test_installer_with_pypi_repository

	# Works with network, but otherwise: Backend 'poetry.core.masonry.api' is not available.
	tests/installation/test_chef.py::test_prepare_sdist
	tests/installation/test_chef.py::test_prepare_directory
	tests/installation/test_chef.py::test_prepare_directory_with_extensions
	tests/installation/test_chef.py::test_prepare_directory_editable
)

distutils_enable_tests pytest
