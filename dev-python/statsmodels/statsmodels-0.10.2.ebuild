# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 eutils

DESCRIPTION="Statistical computations and models for use with SciPy"
HOMEPAGE="https://www.statsmodels.org/stable/index.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.23.0[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/jupyter_client[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# Prevent un-needed d'loading
	sed -e "/sphinx.ext.intersphinx/d" -i docs/source/conf.py || die
	export VARTEXFONTS="${T}"/fonts
	export MPLCONFIGDIR="${T}"
	echo "backend : Agg" > "${MPLCONFIGDIR}"/matplotlibrc || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_sphinx -b html --build-dir=docs/build
}

python_test() {
	cd "${BUILD_DIR}" || die
	${EPYTHON} -c 'import statsmodels; statsmodels.test()' || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Plotting functionality" "dev-python/matplotlib"
}
