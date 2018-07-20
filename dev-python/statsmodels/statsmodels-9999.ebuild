# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1 git-r3 virtualx

DESCRIPTION="Statistical computations and models for use with SciPy"
HOMEPAGE="https://www.statsmodels.org/stable/index.html"
SRC_URI=""
EGIT_REPO_URI="https://github.com/statsmodels/statsmodels.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test"

CDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
RDEPEND="${CDEPEND}
	examples? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
"
DEPEND="${CDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/jupyter_client[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	# Prevent un-needed d'loading
	sed -e "/sphinx.ext.intersphinx/d" -i docs/source/conf.py || die
	export VARTEXFONTS="${T}"/fonts
	export MPLCONFIGDIR="${T}"
	export HOME="${T}"
	echo "backend : Agg" > "${MPLCONFIGDIR}"/matplotlibrc || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		esetup.py build_sphinx -b html --build-dir=docs/build
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_test() {
	cd "${BUILD_DIR}" || die
	${EPYTHON} -c 'import statsmodels; statsmodels.test(exit=True)' || die
}

python_install_all() {
	find "${S}" -name \*LICENSE.txt -delete
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Plotting functionality" "dev-python/matplotlib"
}
