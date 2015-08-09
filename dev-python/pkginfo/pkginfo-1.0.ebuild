# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Provides an API for querying the distutils metadata written in a PKG-INFO file"
HOMEPAGE="http://pypi.python.org/pypi/pkginfo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 x86"
IUSE="doc examples"

LICENSE="MIT"
SLOT="0"
DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare_all() {
	sed -e  's:SPHINXBUILD   = sphinx-build:SPHINXBUILD   = /usr/bin/sphinx-build:' \
		-i docs/Makefile || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	pushd pkginfo/tests/ > /dev/null
	for test in test_*.py; do
		${PYTHON} ${test} || die "${test} failed with Python ${PYTHON_ABI}"
		if [[ $? ]]; then
			einfo "Test ${test} successful"
		else
			die "Test ${test} failed under ${EPYTHON}"
		fi
	done
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/.build/html/. )
	use examples && local EXAMPLES=( docs/examples/. )
	distutils-r1_python_install_all
}
