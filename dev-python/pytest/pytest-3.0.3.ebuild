# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Simple powerful testing with Python"
HOMEPAGE="http://pytest.org/ https://pypi.python.org/pypi/pytest"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86"
IUSE="doc test"

# When bumping, please check setup.py for the proper py version
PY_VER="1.4.29"
COMMON_DEPEND="
	>=dev-python/py-${PY_VER}[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"
DEPEND="${COMMON_DEPEND}
	test? (
		>=dev-python/hypothesis-3.5.2[${PYTHON_USEDEP}]
		>dev-python/pytest-xdist-1.13[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"
RDEPEND="${COMMON_DEPEND}
	!dev-python/logilab-common
"

python_prepare_all() {
	chmod o-w *egg*/* || die
	# Disable versioning of py.test script to avoid collision with
	# versioning performed by the eclass.
	sed -e "s/return points/return {'py.test': target}/" -i setup.py || die "sed failed"
	grep -qF "py>=${PY_VER}" setup.py || die "Incorrect dev-python/py dependency"

	# https://bugs.gentoo.org/598442
	rm testing/test_pdb.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# test_nose.py not written to suit py3.2 in pypy3
	if [[ "${EPYTHON}" == pypy3 ]]; then
		"${PYTHON}" "${BUILD_DIR}"/lib/pytest.py -vv \
			--ignore=testing/BUILD_nose.py \
			|| die "tests failed with ${EPYTHON}"
	else
		"${PYTHON}" "${BUILD_DIR}"/lib/pytest.py -v testing || die "tests failed with ${EPYTHON}"
	fi
}

python_compile_all(){
	use doc && emake -C doc/en html
}

python_install_all() {
	use doc && HTML_DOCS=( doc/en/_build/html/. )
	distutils-r1_python_install_all
}
