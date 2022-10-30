# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="A framework for managing and maintaining multi-language Git pre-commit hooks"
HOMEPAGE="https://pre-commit.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

RDEPEND="dev-vcs/git
	$(python_gen_cond_dep '
		>=dev-python/cfgv-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/identify-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/nodeenv-0.11.1[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-20.0.8[${PYTHON_USEDEP}]
	')"
BDEPEND="test? (
	$(python_gen_cond_dep '
		dev-python/pytest-env[${PYTHON_USEDEP}]
		dev-python/re-assert[${PYTHON_USEDEP}]
	')
)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.20.0-no_toml.patch
)

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

# The former two require a boatload of dependencies (e.g. Conda, Go, R and more) in order to run
# and while some of them do include "skip if not found" logic, most of them do not.
# The latter consistently fail with
#     Calling "git rev-parse" fails with "fatal: not a git repository (or any of the parent directories): .git".
# including with the sandbox disabled and when run manually with tox.
EPYTEST_DESELECT=(
	tests/languages/
	tests/repository_test.py
	tests/main_test.py::test_all_cmds
	tests/main_test.py::test_try_repo
)

distutils_enable_tests pytest
