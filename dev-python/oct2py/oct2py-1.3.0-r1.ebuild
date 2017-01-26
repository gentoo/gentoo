# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Python to GNU Octave bridge"
HOMEPAGE="https://pypi.python.org/pypi/oct2py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	sci-libs/scipy[${PYTHON_USEDEP}]
	<sci-mathematics/octave-3.8"
DEPEND="${RDEPEND}
	doc? (
		dev-python/sphinx-bootstrap-theme[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${P}-test.patch"
	)
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build docs html || die
	fi
}

python_test() {
	unset DISPLAY
	if [[ ${EPYTHON} == python2.7 ]]; then
		local OPTIONS="--with-doctest"
	fi
	nosetests oct2py ${OPTIONS} || die "Tests fail with ${EPYTHON}"
	iptest -v IPython.extensions.tests.test_octavemagic || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( html/. )
	use examples && EXAMPLES=( example/. )
	distutils-r1_python_install_all
}
