# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 virtualx

DESCRIPTION="Statistical computations and models for use with SciPy"
HOMEPAGE="http://statsmodels.sourceforge.net/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

CDEPEND="
	>=dev-python/numpy-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/patsy-0.3.0[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.9.0[${PYTHON_USEDEP}]
	"
RDEPEND="${CDEPEND}
	examples? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"
DEPEND="${CDEPEND}
	>=dev-python/cython-0.20.1[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/matplotlib-1.1[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		)
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${P}-pandas-0.17.0.patch
	"${FILESDIR}"/${P}-numpy-1.10.patch
)

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

pkg_postinst() {
	optfeature "plotting functionality" ">=dev-python/matplotlib-1.1"
}
