# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Statistical computations and models for use with SciPy"
HOMEPAGE="
	https://www.statsmodels.org/stable/index.html
	https://github.com/statsmodels/statsmodels/
	https://pypi.org/project/statsmodels/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~riscv ~amd64-linux"
IUSE="examples"

# NB: upstream requires building with numpy-2 but supports 1.x
# at runtime
DEPEND="
	>=dev-python/numpy-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.8[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/numpy-1.22.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.4[${PYTHON_USEDEP}]
	>=dev-python/patsy-0.5.6[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.8[${PYTHON_USEDEP}]
"
BDEPEND="
	${DEPEND}
	>=dev-python/cython-3.0.10[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	'dev-python/ipykernel' \
	'dev-python/jupyter-client' \
	'dev-python/matplotlib' \
	'dev-python/nbconvert' \
	'dev-python/numpydoc'

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_prepare_all() {
	export VARTEXFONTS="${T}"/fonts
	export MPLCONFIGDIR="${T}"
	printf -- 'backend : Agg\n' > "${MPLCONFIGDIR}"/matplotlibrc || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x MKL_NUM_THREADS=1
	local -x OMP_NUM_THREADS=1
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1

	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest statsmodels
}

python_install_all() {
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Plotting functionality" "dev-python/matplotlib"
}
