# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )

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

# dev-python/build: 1.0 breaks backward compatibility
# https://github.com/python-poetry/poetry/issues/8434
RDEPEND="
	>=dev-python/poetry-core-1.9.0[${PYTHON_USEDEP}]
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
	>=dev-python/pkginfo-1.9.4[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/shellingham-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.11.6[${PYTHON_USEDEP}]
	>=dev-python/trove-classifiers-2022.5.19[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.0[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.23.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	' 3.10)
"

BDEPEND="
	test? (
			>=dev-python/deepdiff-6.3.1[${PYTHON_USEDEP}]
			>=dev-python/httpretty-1.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-3.9[${PYTHON_USEDEP}]
			>=dev-python/pytest-xdist-3.1[${PYTHON_USEDEP}]
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
	# Tests require network (they run `pip install ...`)
	tests/installation/test_chef.py::test_isolated_env_install_success
	tests/installation/test_executor.py::test_executor_should_write_pep610_url_references_for_directories
	tests/installation/test_executor.py::test_executor_should_write_pep610_url_references_for_git
	tests/installation/test_executor.py::test_executor_should_write_pep610_url_references_for_git_with_subdirectories
	tests/installation/test_executor.py::test_executor_should_write_pep610_url_references_for_non_wheel_files
	tests/installation/test_installer.py::test_installer_with_pypi_repository
	tests/installation/test_pip_installer.py::test_uninstall_git_package_nspkg_pth_cleanup
	tests/masonry/builders/test_editable_builder.py::test_builder_setup_generation_runs_with_pip_editable

	# Works with network, but otherwise: Backend 'poetry.core.masonry.api' is not available.
	tests/installation/test_chef.py::test_prepare_sdist
	tests/installation/test_chef.py::test_prepare_directory
	tests/installation/test_chef.py::test_prepare_directory_with_extensions
	tests/installation/test_chef.py::test_prepare_directory_editable

	# Internal test for lockfile being up-to-date
	# Meaningless, also sdist does not include lockfile
	tests/installation/test_installer.py::test_not_fresh_lock

	# TODO
	tests/installation/test_executor.py::test_executor_known_hashes
	tests/utils/env/test_env_manager.py::test_create_venv_finds_no_python_executable
)

distutils_enable_tests pytest
