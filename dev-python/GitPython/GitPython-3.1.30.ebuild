# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

TEST_P=GitPython-${PV}
GITDB_P=gitdb-4.0.10
SMMAP_P=smmap-5.0.0

DESCRIPTION="Library used to interact with Git repositories"
HOMEPAGE="
	https://github.com/gitpython-developers/GitPython/
	https://pypi.org/project/GitPython/
"
SRC_URI="
	mirror://pypi/${PN::1}/${PN}/${P}.tar.gz
	test? (
		https://dev.gentoo.org/~mgorny/dist/${TEST_P}.gitbundle
		https://dev.gentoo.org/~mgorny/dist/${GITDB_P}.gitbundle
		https://dev.gentoo.org/~mgorny/dist/${SMMAP_P}.gitbundle
	)
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-vcs/git
	>=dev-python/gitdb-4.0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/ddt-1.1.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_test() {
	git config --global user.email "travis@ci.com" || die
	git config --global user.name "Travis Runner" || die

	git clone "${DISTDIR}/${TEST_P}.gitbundle" "${T}"/test || die
	git clone "${DISTDIR}/${GITDB_P}.gitbundle" \
		"${T}"/test/git/ext/gitdb || die
	git clone "${DISTDIR}/${SMMAP_P}.gitbundle" \
		"${T}"/test/git/ext/gitdb/gitdb/ext/smmap || die

	cd "${T}"/test || die
	git rev-parse HEAD > .git/refs/remotes/origin/master || die
	TRAVIS=1 ./init-tests-after-clone.sh || die
	cat test/fixtures/.gitconfig >> ~/.gitconfig || die

	distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# performance tests are unreliable by design
		test/performance
		# unimpoortant and problematic
		test/test_installation.py
		# Internet
		test/test_repo.py::TestRepo::test_leaking_password_in_clone_logs
		# requires which(1)
		# https://github.com/gitpython-developers/GitPython/pull/1525
		test/test_git.py::TestGit::test_refresh
		# TODO
		test/test_submodule.py::TestSubmodule::test_base_rw
		test/test_submodule.py::TestSubmodule::test_git_submodules_and_add_sm_with_new_commit
		test/test_submodule.py::TestSubmodule::test_list_only_valid_submodules
		test/test_submodule.py::TestSubmodule::test_root_module
	)

	epytest test
}
