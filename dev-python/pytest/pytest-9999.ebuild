# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1 git-r3

DESCRIPTION="simple powerful testing with Python"
HOMEPAGE="http://pytest.org/ https://pypi.python.org/pypi/pytest"
SRC_URI=""
EGIT_REPO_URI="https://github.com/pytest-dev/pytest.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

# When bumping, please check setup.py for the proper py version
PY_VER="1.4.29"
RDEPEND=">=dev-python/py-${PY_VER}[${PYTHON_USEDEP}]"

# dev-python/pluggy
# https://github.com/hpk42/pluggy
# See https://github.com/pytest-dev/pytest/issues/944
# for why not now

#pexpect dep based on https://bitbucket.org/hpk42/pytest/issue/386/tests-fail-with-pexpect-30
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (	dev-python/pexpect[${PYTHON_USEDEP}] )
	doc? (
		>=dev-python/sphinx-1.2.3[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/regendoc[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# Disable versioning of py.test script to avoid collision with
	# versioning performed by the eclass.
	sed -e "s/return points/return {'py.test': target}/" -i setup.py || die "sed failed"
	grep -qF "py>=${PY_VER}" setup.py || die "Incorrect dev-python/py dependency"

	# Prevent un-needed d'loading
	sed -e "s/'sphinx.ext.intersphinx', //" -i doc/en/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		mkdir doc/en/.build || die
		emake -C doc/en html
	fi
}

python_test() {
	# test_nose.py not written to suit py3.2 in pypy3
	if [[ "${EPYTHON}" == pypy3 ]]; then
		"${PYTHON}" "${BUILD_DIR}"/lib/pytest.py -x -v \
			--ignore=testing/BUILD_nose.py \
			|| die "tests failed with ${EPYTHON}"
	else
		"${PYTHON}" "${BUILD_DIR}"/lib/pytest.py -x -v --runpytest=subprocess \
			|| die "tests failed with ${EPYTHON}"
	fi
}

python_install_all() {
	use doc && HTML_DOCS=( doc/en/_build/html/. )
	distutils-r1_python_install_all
}
