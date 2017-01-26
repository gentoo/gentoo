# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Statistical computations and models for use with SciPy"
HOMEPAGE="http://statsmodels.sourceforge.net/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	examples? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"
DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	doc? (
		dev-python/matplotlib
		dev-python/sphinx
		dev-python/ipython )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

pkg_setup() {
	export MPLCONFIGDIR="${T}" HOME="${T}"
}

python_compile_all() {
	if use doc; then
		VARTEXFONTS="${T}"/fonts ${EPYTHON} setup.py build_sphinx || die
	fi
}

python_test() {
	cd "${BUILD_DIR}" || die
	VIRTUALX_COMMAND="nosetests"
	virtualmake --verbosity=3
}

python_install() {
	distutils-r1_python_install
	rm -r "${D}/$(python_get_sitedir)/statsmodels/examples" || die
}

python_install_all() {
	find "${S}" -name \*LICENSE.txt -delete
	use doc && HTML_DOCS=( build/sphinx/html/* )
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
	distutils-r1_python_install_all
}
