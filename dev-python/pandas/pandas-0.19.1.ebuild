# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE="threads(+)"

VIRTUALX_REQUIRED="manual"

inherit distutils-r1 eutils flag-o-matic virtualx

DESCRIPTION="Powerful data structures for data analysis and statistics"
HOMEPAGE="http://pandas.pydata.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc -minimal full-support test X"

MINIMAL_DEPEND="
	>dev-python/numpy-1.7[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.0[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	!<dev-python/numexpr-2.1[${PYTHON_USEDEP}]
	!~dev-python/openpyxl-1.9.0[${PYTHON_USEDEP}]"
RECOMMENDED_DEPEND="
	dev-python/bottleneck[${PYTHON_USEDEP}]
	>=dev-python/numexpr-2.1[${PYTHON_USEDEP}]"
OPTIONAL_DEPEND="
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/blosc[${PYTHON_USEDEP}]
	dev-python/boto[${PYTHON_USEDEP}]
	>=dev-python/google-api-python-client-1.2.0[$(python_gen_usedep python2_7 pypy)]
	|| ( dev-python/html5lib[${PYTHON_USEDEP}] dev-python/lxml[${PYTHON_USEDEP}] )
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	|| ( >=dev-python/openpyxl-1.6.1[${PYTHON_USEDEP}] dev-python/xlsxwriter[${PYTHON_USEDEP}] )
	>=dev-python/pytables-3.2.1[${PYTHON_USEDEP}]
	dev-python/python-gflags[$(python_gen_usedep python2_7 pypy)]
	dev-python/rpy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.8.1[${PYTHON_USEDEP}]
	dev-python/xlrd[${PYTHON_USEDEP}]
	dev-python/xlwt[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	X? (
		|| (
			dev-python/PyQt4[${PYTHON_USEDEP}]
			dev-python/pyside[${PYTHON_USEDEP}]
			dev-python/pygtk[$(python_gen_usedep python2_7)]
		)
		|| (
			x11-misc/xclip
			x11-misc/xsel
		)
	)
	"

DEPEND="${MINIMAL_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/cython-0.19.1[${PYTHON_USEDEP}]
	doc? (
		${VIRTUALX_DEPEND}
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/pytables-3.0.0[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/rpy[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.2.1[${PYTHON_USEDEP}]
		dev-python/xlrd[${PYTHON_USEDEP}]
		dev-python/xlwt[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
		x11-misc/xclip
	)
	test? (
		${VIRTUALX_DEPEND}
		${RECOMMENDED_DEPEND}
		${OPTIONAL_DEPEND}
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pymysql[${PYTHON_USEDEP}]
		dev-python/psycopg:2[${PYTHON_USEDEP}]
		x11-misc/xclip
		x11-misc/xsel
	)"
# dev-python/statsmodels invokes a circular dep
#  hence rm from doc? ( ), again
RDEPEND="
	${MINIMAL_DEPEND}
	!minimal? ( ${RECOMMENDED_DEPEND} )
	full-support? ( ${OPTIONAL_DEPEND} )"

PATCHES=(
	"${FILESDIR}"/${P}-gapi.patch
	"${FILESDIR}"/${P}-seqf.patch
)

python_prepare_all() {
	# Prevent un-needed download during build
	sed -e "/^              'sphinx.ext.intersphinx',/d" -i doc/source/conf.py || die

	# https://github.com/pydata/pandas/issues/11299
	sed \
		-e 's:testOdArray:disable:g' \
		-i pandas/io/tests/json/test_ujson.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	# To build docs the need be located in $BUILD_DIR,
	# else PYTHONPATH points to unusable modules.
	if use doc; then
		cd "${BUILD_DIR}"/lib || die
		cp -ar "${S}"/doc . && cd doc || die
		LANG=C PYTHONPATH=. virtx ${EPYTHON} make.py html || die
	fi
}

python_test() {
	local test_pandas='not network and not disabled'
	[[ -n "${FAST_PANDAS}" ]] && test_pandas+=' and not slow'
	pushd  "${BUILD_DIR}"/lib > /dev/null
	"${EPYTHON}" -c "import pandas; pandas.show_versions()" || die
	PYTHONPATH=. MPLCONFIGDIR=. \
		virtx nosetests --verbosity=3 -A "${test_pandas}" pandas
	popd > /dev/null
}

python_install_all() {
	if use doc; then
		dodoc -r "${BUILD_DIR}"/lib/doc/build/html
		einfo "An initial build of docs is absent of references to statsmodels"
		einfo "due to circular dependency. To have them included, emerge"
		einfo "statsmodels next and re-emerge pandas with USE doc"
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "accelerating certain types of NaN evaluations, using specialized cython routines to achieve large speedups." dev-python/bottleneck
	optfeature "accelerating certain numerical operations, using multiple cores as well as smart chunking and caching to achieve large speedups" >=dev-python/numexpr-2.1
	optfeature "needed for pandas.io.html.read_html" dev-python/beautifulsoup:4 dev-python/html5lib dev-python/lxml
	optfeature "for msgpack compression using ``blosc``" dev-python/blosc
	optfeature "necessary for Amazon S3 access" dev-python/boto
	optfeature "needed for pandas.io.gbq" dev-python/httplib2 dev-python/setuptools dev-python/python-gflags >=dev-python/google-api-python-client-1.2.0
	optfeature "Template engine for conditional HTML formatting" dev-python/jinja
	optfeature "Plotting support" dev-python/matplotlib
	optfeature "Needed for Excel I/O" >=dev-python/openpyxl-1.6.1 dev-python/xlsxwriter dev-python/xlrd dev-python/xlwt
	optfeature "necessary for HDF5-based storage" >=dev-python/pytables-3.2.1
	optfeature "R I/O support" dev-python/rpy
	optfeature "Needed for parts of :mod:`pandas.stats`" dev-python/statsmodels
	optfeature "SQL database support" >=dev-python/sqlalchemy-0.8.1
	optfeature "miscellaneous statistical functions" sci-libs/scipy
	optfeature "necessary to use ~pandas.io.clipboard.read_clipboard support" dev-python/PyQt4 dev-python/pyside dev-python/pygtk x11-misc/xclip x11-misc/xsel
}
