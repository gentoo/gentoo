# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

TEST_P=GitPython-3.1.0
GITDB_P=gitdb-4.0.2
SMMAP_P=smmap-3.0.1

DESCRIPTION="Library used to interact with Git repositories"
HOMEPAGE="https://github.com/gitpython-developers/GitPython https://pypi.org/project/GitPython/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz
	test? (
		https://dev.gentoo.org/~mgorny/dist/${TEST_P}.gitbundle
		https://dev.gentoo.org/~mgorny/dist/${GITDB_P}.gitbundle
		https://dev.gentoo.org/~mgorny/dist/${SMMAP_P}.gitbundle
	)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-vcs/git
	>=dev-python/gitdb-4.0.1[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		>=dev-python/ddt-1.1.1[${PYTHON_USEDEP}]
	)"

distutils_enable_tests unittest

src_test() {
	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die

	git clone "${DISTDIR}/${TEST_P}.gitbundle" "${T}"/test || die
	git clone "${DISTDIR}/${GITDB_P}.gitbundle" \
		"${T}"/test/git/ext/gitdb || die
	git clone "${DISTDIR}/${SMMAP_P}.gitbundle" \
		"${T}"/test/git/ext/gitdb/gitdb/ext/smmap || die

	cd "${T}"/test || die
	# remove performance tests
	rm -r git/test/performance || die
	# tests requiring network access
	sed -i -e 's:test_fetch_error:_&:' git/test/test_remote.py || die
	# broken apparently
	sed -i -e 's:test_rev_parse:_&:' git/test/test_repo.py || die

	distutils-r1_src_test
}
