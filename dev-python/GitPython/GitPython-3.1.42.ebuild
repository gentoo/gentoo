# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

TEST_P=GitPython-${PV}
GITDB_P=gitdb-4.0.11
SMMAP_P=smmap-5.0.1

DESCRIPTION="Library used to interact with Git repositories"
HOMEPAGE="
	https://github.com/gitpython-developers/GitPython/
	https://pypi.org/project/GitPython/
"
SRC_URI+="
	test? (
		https://dev.gentoo.org/~mgorny/dist/${TEST_P}.gitbundle
		https://dev.gentoo.org/~mgorny/dist/${GITDB_P}.gitbundle
		https://dev.gentoo.org/~mgorny/dist/${SMMAP_P}.gitbundle
	)
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-vcs/git
	>=dev-python/gitdb-4.0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/ddt-1.1.1[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
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
		# unimportant and problematic
		test/test_installation.py
		# Internet
		test/test_quick_doc.py::QuickDoc::test_cloned_repo_object
		# TODO
		test/test_submodule.py::TestSubmodule::test_base_rw
		test/test_submodule.py::TestSubmodule::test_root_module
	)

	epytest -o addopts= test
}
