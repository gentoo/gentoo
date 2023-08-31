# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="threads(+)"

VIRTUALX_REQUIRED="manual"

inherit distutils-r1 multiprocessing optfeature virtualx

DESCRIPTION="Powerful data structures for data analysis and statistics"
HOMEPAGE="
	https://pandas.pydata.org/
	https://github.com/pandas-dev/pandas/
	https://pypi.org/project/pandas/
"
SRC_URI="
	https://github.com/pandas-dev/pandas/releases/download/v${PV}/${P}.tar.gz
"
S=${WORKDIR}/${P/_/}

SLOT="0"
LICENSE="BSD"
# new meson build that:
# 1) sometimes fails on .pxi.in → .pyx ordering
#    https://github.com/pandas-dev/pandas/issues/54889
# 2) creates a broken wheel with two pandas/_libs/__init__.py files
#    https://github.com/pandas-dev/pandas/issues/54888
KEYWORDS=""
IUSE="full-support minimal test X"
RESTRICT="!test? ( test )"

RECOMMENDED_DEPEND="
	>=dev-python/bottleneck-1.3.4[${PYTHON_USEDEP}]
	>=dev-python/numexpr-2.8.0[${PYTHON_USEDEP}]
"

# TODO: add pandas-gbq to the tree
# TODO: Re-add dev-python/statsmodel[python3_11] dep once it supports python3_11
# https://github.com/statsmodels/statsmodels/issues/8287
OPTIONAL_DEPEND="
	>=dev-python/beautifulsoup4-4.11.1[${PYTHON_USEDEP}]
	dev-python/blosc[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.1.2[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.6.1[${PYTHON_USEDEP}]
	>=dev-python/openpyxl-3.0.7[${PYTHON_USEDEP}]
	>=dev-python/pytables-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.4.36[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.8.10[${PYTHON_USEDEP}]
	>=dev-python/xarray-2022.3.0[${PYTHON_USEDEP}]
	>=dev-python/xlrd-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/xlsxwriter-3.0.3[${PYTHON_USEDEP}]
	>=dev-python/xlwt-1.3.0[${PYTHON_USEDEP}]
	!hppa? (
		$(python_gen_cond_dep '
			dev-python/statsmodels[${PYTHON_USEDEP}]
		' python3_{8..10} )
		>=dev-python/scipy-1.8.1[${PYTHON_USEDEP}]
	)
	X? (
		|| (
			>=dev-python/PyQt5-5.15.6[${PYTHON_USEDEP}]
			>=dev-python/QtPy-2.2.0[${PYTHON_USEDEP}]
			x11-misc/xclip
			x11-misc/xsel
		)
	)
"
DEPEND="
	>=dev-python/numpy-1.23.2[${PYTHON_USEDEP}]
"
COMMON_DEPEND="
	${DEPEND}
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/pytz-2020.1[${PYTHON_USEDEP}]
"
BDEPEND="
	${COMMON_DEPEND}
	>=dev-python/cython-0.29.33[${PYTHON_USEDEP}]
	>=dev-python/versioneer-0.28[${PYTHON_USEDEP}]
	test? (
		${VIRTUALX_DEPEND}
		${RECOMMENDED_DEPEND}
		${OPTIONAL_DEPEND}
		>=dev-python/beautifulsoup4-4.11.1[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.46.1[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-3.0.10[${PYTHON_USEDEP}]
		>=dev-python/pymysql-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.3.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.17.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/psycopg-2.9.3:2[${PYTHON_USEDEP}]
		>=dev-python/xlsxwriter-3.0.3[${PYTHON_USEDEP}]
		x11-misc/xclip
		x11-misc/xsel
	)
"
RDEPEND="
	${COMMON_DEPEND}
	dev-python/tzdata[${PYTHON_USEDEP}]
	!minimal? ( ${RECOMMENDED_DEPEND} )
	full-support? ( ${OPTIONAL_DEPEND} )
"

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local -x LC_ALL=C.UTF-8
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	"${EPYTHON}" -c "import pandas; pandas.show_versions()" || die
	epytest pandas --skip-slow --skip-network -m "not single" \
		-n "$(makeopts_jobs)" || die "Tests failed with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "accelerating certain types of NaN evaluations, using specialized cython routines to achieve large speedups." dev-python/bottleneck
	optfeature "accelerating certain numerical operations, using multiple cores as well as smart chunking and caching to achieve large speedups" ">=dev-python/numexpr-2.1"
	optfeature "needed for pandas.io.html.read_html" dev-python/beautifulsoup4 dev-python/html5lib dev-python/lxml
	optfeature "for msgpack compression using blosc" dev-python/blosc
	optfeature "Template engine for conditional HTML formatting" dev-python/jinja
	optfeature "Plotting support" dev-python/matplotlib
	optfeature "Needed for Excel I/O" ">=dev-python/openpyxl-3.0.10" dev-python/xlsxwriter dev-python/xlrd dev-python/xlwt
	optfeature "necessary for HDF5-based storage" ">=dev-python/pytables-3.7.0"
	optfeature "R I/O support" dev-python/rpy
	optfeature "Needed for parts of pandas.stats" dev-python/statsmodels
	optfeature "SQL database support" ">=dev-python/sqlalchemy-1.4.36"
	optfeature "miscellaneous statistical functions" dev-python/scipy
	optfeature "necessary to use pandas.io.clipboard.read_clipboard support" dev-python/PyQt5 dev-python/QtPy dev-python/pygtk x11-misc/xclip x11-misc/xsel
}
