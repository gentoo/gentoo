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
# even with the environment variables normally handled by pytest-env (which we haven't got in the tree yet)
# explicitly declared in python_test().
#RESTRICT="test"

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
	$(python_gen_cond_dep 'dev-python/re-assert[${PYTHON_USEDEP}]')
)"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

distutils_enable_tests --install pytest

src_prepare() {
	default

	# These tests require a boatload of dependencies (e.g. Conda, Go, R and more) in order to run
	# and while some of them do include "skip if not found" logic, most of them do not.
	rm -rf tests/languages tests/repository_test.py
}

python_test() {
	# TODO: add pytest-env to the tree so that these can be read from tox.ini
	declare -x GIT_AUTHOR_NAME=test
	declare -x GIT_COMMITTER_NAME=test
	declare -x GIT_AUTHOR_EMAIL=test@example.com
	declare -x GIT_COMMITTER_EMAIL=test@example.com
	declare -x VIRTUALENV_NO_DOWNLOAD=1
	declare -x PRE_COMMIT_NO_CONCURRENCY=1

	distutils-r1_python_test
}
