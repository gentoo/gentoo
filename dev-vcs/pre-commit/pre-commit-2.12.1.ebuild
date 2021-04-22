# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="A framework for managing and maintaining multi-language Git pre-commit hooks"
HOMEPAGE="https://pre-commit.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# TODO: figure out why these tests - all of which invoke git - fail:
#  - tests/main_test.py::test_all_cmds[autoupdate,hook-impl,install,install-hooks,migrate-config,run,uninstall]
#     "Git failed", not much information beyond that
#  - tests/main_test.py::test_try_repo
#     Ditto
#  - tests/commands/install_uninstall_test.py::test_installed_from_venv
#     "git commit" returns 1 instead of 0, again no details
RESTRICT="test"

RDEPEND="dev-vcs/git
	$(python_gen_cond_dep '
		dev-python/cfgv[${PYTHON_USEDEP}]
		dev-python/identify[${PYTHON_USEDEP}]
		dev-python/nodeenv[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-20.0.8[${PYTHON_USEDEP}]
	')"
BDEPEND="test? (
	$(python_gen_cond_dep '
		dev-python/pytest-env[${PYTHON_USEDEP}]
		dev-python/re-assert[${PYTHON_USEDEP}]
	')
)"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

distutils_enable_tests --install pytest

src_prepare() {
	default

	# These tests require a boatload of dependencies (e.g. Conda, Go, R and more) in order to run
	# and while some of them do include "skip if not found" logic, most of them do not.
	rm -rf tests/languages tests/repository_test.py
}
