# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python multiprocessing fork"
HOMEPAGE="https://pypi.python.org/pypi/billiard https://github.com/celery/billiard"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/unittest2-0.4.0[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose-cover3[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy pypy3 )
	)"
# The usual req'd for tests
DISTUTILS_IN_SOURCE_BUILD=1

python_compile() {
	if !  python_is_python3; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && esetup.py build_sphinx --builder="html" --source-dir=Doc/
}

python_test() {
	cd "${BUILD_DIR}" || die
	# The teardown in __init__.py breaks pypy's installed nose
	if [[ "${EPYTHON}" == pypy ]]; then
		rm lib/billiard/tests/__init__.py || die
		echo "from __future__ import absolute_import" >> ./lib/billiard/tests/__init__.py || die
	fi
	nosetests billiard.tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( build/sphinx/html/. )
	distutils-r1_python_install_all
}
