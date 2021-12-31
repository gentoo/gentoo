# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python to GNU Octave bridge"
HOMEPAGE="
	https://github.com/blink1073/oct2py
	https://blink1073.github.io/oct2py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	>=dev-python/numpy-1.7.1[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.12[${PYTHON_USEDEP}]
	>=sci-mathematics/octave-4.2.0"
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
	# https://github.com/blink1073/oct2py/issues/77
	sed \
		-e 's:test_help:disabled:g' \
		-i oct2py/tests/test_usage.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build docs html || die
	fi
}

python_test() {
	unset DISPLAY
	[[ ${EPYTHON} == python2.7 ]] && local OPTIONS="--with-doctest"
	nosetests --exe -v oct2py ${OPTIONS} || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( html/. )
	if use examples; then
		docinto examples
		dodoc -r example/.
	fi

	distutils-r1_python_install_all
}
