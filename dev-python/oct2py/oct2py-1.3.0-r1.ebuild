# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/oct2py/oct2py-1.3.0-r1.ebuild,v 1.9 2015/03/09 00:04:26 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python to GNU Octave bridge"
HOMEPAGE="http://pypi.python.org/pypi/oct2py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-mathematics/octave"
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
	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r example
	fi
}
