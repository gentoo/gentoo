# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

MY_PN="${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="CFFI-based drop-in replacement for Pycairo"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
HOMEPAGE="https://github.com/SimonSapin/cairocffi"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 x86"
IUSE="doc test"

RDEPEND="
	$(python_gen_cond_dep '>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]' 'python*')
	>=dev-python/xcffib-0.3.2[${PYTHON_USEDEP}]
	x11-libs/cairo:0=
	x11-libs/gdk-pixbuf[jpeg]
	$(python_gen_cond_dep '>=virtual/pypy-2.6.0' pypy )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	$(python_gen_cond_dep '>=virtual/pypy-2.6.0' pypy )"

PATCHES=(
	# Intersphinx cause the usual d'loading of objects.inv from TWO online sites
	 "${FILESDIR}"/mapping.patch
	 "${FILESDIR}"/${PN}-0.7.1-test.patch
	 )

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	py.test -v --pyargs cairocffi || die "testsuite failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
