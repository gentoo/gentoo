# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Simple powerful testing with Python"
HOMEPAGE="http://pytest.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# When bumping, please check setup.py for the proper py version
PY_VER="1.5.0"

# pathlib2 has been added to stdlib before py3.6, but pytest needs __fspath__
# support, which only came in py3.6.
RDEPEND="
	>=dev-python/atomicwrites-1.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-17.4.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/more-itertools-4.0.0[${PYTHON_USEDEP}]' python2_7 )
	$(python_gen_cond_dep '<dev-python/more-itertools-6.0.0[${PYTHON_USEDEP}]' python2_7 )
	$(python_gen_cond_dep '>=dev-python/more-itertools-4.0.0[${PYTHON_USEDEP}]' python3_{6,7} pypy{,3} )
	$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' python2_7)
	>=dev-python/pluggy-0.7[${PYTHON_USEDEP}]
	>=dev-python/py-${PY_VER}[${PYTHON_USEDEP}]
	>=dev-python/setuptools-40[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	virtual/python-funcsigs[${PYTHON_USEDEP}]"

# flake & pytest-capturelog cause a number of tests to fail
DEPEND="${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hypothesis-3.56[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' -2)
		dev-python/requests[${PYTHON_USEDEP}]
		!!dev-python/flaky
		!!dev-python/pytest-capturelog
		!!<dev-python/pytest-xdist-1.22
	)"

python_prepare_all() {
	grep -qF "py>=${PY_VER}" setup.py || die "Incorrect dev-python/py dependency"

	# Something in the ebuild environment causes this to hang/error.
	# https://bugs.gentoo.org/598442
	rm testing/test_pdb.py || die

	# those tests appear to hang with python3.5+;  TODO: investigate why
	sed -i -e 's:test_runtest_location_shown_before_test_starts:_&:' \
		testing/test_terminal.py || die
	sed -i -e 's:test_trial_pdb:_&:' testing/test_unittest.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" "${BUILD_DIR}"/lib/pytest.py --lsof -rfsxX \
		-vv testing || die "tests failed with ${EPYTHON}"
}
