# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Simple powerful testing with Python"
HOMEPAGE="http://pytest.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc64 ~sparc ~x86"
# doc apparently requires sphinxcontrib_trio, not yet packaged
IUSE="test" # doc

# When bumping, please check setup.py for the proper py version
PY_VER="1.5.0"

# pathlib2 has been added to stdlib before py3.6, but pytest needs __fspath__
# support, which only came in py3.6.
COMMON_DEPEND="
	>=dev-python/atomicwrites-1.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-17.4.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-4.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' python2_7 python3_{4,5} )
	>=dev-python/pluggy-0.7[${PYTHON_USEDEP}]
	>=dev-python/py-${PY_VER}[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	virtual/python-funcsigs[${PYTHON_USEDEP}]"

#	doc? (
#		dev-python/pyyaml[${PYTHON_USEDEP}]
#		dev-python/sphinx[${PYTHON_USEDEP}]
#	)"

# flake & pytest-capturelog cause a number of tests to fail
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hypothesis-3.56[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.22.2[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		!!dev-python/flaky
		!!dev-python/pytest-capturelog
	)"

RDEPEND="
	${COMMON_DEPEND}
	!<dev-python/logilab-common-1.3.0"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/pytest-3.6.3-pypy-syntaxerror-offset.patch
	)

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

#python_compile_all() {
#	use doc && emake -C doc/en html
#}
#
#python_install_all() {
#	use doc && HTML_DOCS=( doc/en/_build/html/. )
#	distutils-r1_python_install_all
#}
