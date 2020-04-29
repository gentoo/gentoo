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
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
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
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/statsmodels-0.11.1-tests.patch"
)

distutils_enable_sphinx docs \
	'dev-python/ipykernel' \
	'dev-python/jupyter_client' \
	'dev-python/matplotlib' \
	'dev-python/nbconvert' \
	'dev-python/numpydoc'

distutils_enable_tests pytest

python_prepare_all() {
	# Prevent un-needed d'loading
	export VARTEXFONTS="${T}"/fonts
	export MPLCONFIGDIR="${T}"
	printf -- 'backend : Agg\n' > "${MPLCONFIGDIR}"/matplotlibrc || die
	distutils-r1_python_prepare_all
}

python_test() {
	pushd "${BUILD_DIR}" >/dev/null || die
	"${EPYTHON}" -c 'import statsmodels; statsmodels.test()' \
		|| die "tests fail with ${EPYTHON}"
	popd >/dev/null || die
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
