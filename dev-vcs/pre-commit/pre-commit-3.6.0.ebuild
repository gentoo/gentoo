# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="A framework for managing and maintaining multi-language Git pre-commit hooks"
HOMEPAGE="https://pre-commit.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~x86"

RDEPEND="dev-vcs/git
	$(python_gen_cond_dep '
		>=dev-python/cfgv-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/identify-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/nodeenv-0.11.1[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-20.10.0[${PYTHON_USEDEP}]
	')"
# coreutils requirement: see Bug #885559
BDEPEND="test? (
	$(python_gen_cond_dep '
		dev-python/pytest-env[${PYTHON_USEDEP}]
		dev-python/re-assert[${PYTHON_USEDEP}]
	')
	sys-apps/coreutils[-multicall]
)"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.1-tests_git_file_transport.patch
)

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

EPYTEST_DESELECT=(
	# All of these require a boatload of dependencies (e.g. Conda, Go, R and more) in order to run
	# and while some of them do include "skip if not found" logic, most of them do not.
	tests/languages/
	tests/repository_test.py
	# These three consistently fail with
	#     Calling "git rev-parse" fails with "fatal: not a git repository (or any of the parent directories): .git".
	# including with the sandbox disabled.
	tests/main_test.py::test_all_cmds
	tests/main_test.py::test_hook_stage_migration
	tests/main_test.py::test_try_repo
	# These two fail if pre-commit is already installed (Bug #894502)
	tests/commands/install_uninstall_test.py::test_environment_not_sourced
	tests/commands/install_uninstall_test.py::test_installed_from_venv
)

distutils_enable_tests pytest
