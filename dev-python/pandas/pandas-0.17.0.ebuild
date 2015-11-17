# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 eutils flag-o-matic virtualx

DESCRIPTION="Powerful data structures for data analysis and statistics"
HOMEPAGE="http://pandas.pydata.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc excel html test R"

EXTRA_DEPEND="
	>=dev-python/google-api-python-client-1.2.0[$(python_gen_usedep python2_7 pypy)]
	dev-python/openpyxl[${PYTHON_USEDEP}]
	dev-python/pymysql[${PYTHON_USEDEP}]
	dev-python/python-gflags[$(python_gen_usedep python2_7 pypy)]
	dev-python/psycopg:2[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	"
CDEPEND="
	>dev-python/numpy-1.7[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.0[${PYTHON_USEDEP}]
	!~dev-python/openpyxl-1.9.0[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	>=dev-python/cython-0.19.1[${PYTHON_USEDEP}]
	doc? (
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/pytables-3.0.0[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/rpy[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.2.1[${PYTHON_USEDEP}]
		dev-python/xlrd[${PYTHON_USEDEP}]
		dev-python/xlwt[${PYTHON_USEDEP}]
		x11-misc/xclip
		)
	test? (
		${EXTRA_DEPEND}
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		x11-misc/xclip
		x11-misc/xsel
		)"
# dev-python/statsmodels invokes a circular dep
#  hence rm from doc? ( ), again
RDEPEND="${CDEPEND}
	>=dev-python/numexpr-2.1[${PYTHON_USEDEP}]
	dev-python/bottleneck[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pytables[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	excel? (
		dev-python/xlrd[${PYTHON_USEDEP}]
		dev-python/xlwt[${PYTHON_USEDEP}]
		|| (
			dev-python/xlsxwriter[${PYTHON_USEDEP}]
			>=dev-python/openpyxl-1.6.1[${PYTHON_USEDEP}]
		)
	)
	html? (
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		|| (
			dev-python/lxml[${PYTHON_USEDEP}]
			dev-python/html5lib[${PYTHON_USEDEP}] )
	)
	R? ( dev-python/rpy[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${P}-testfix-backport.patch
)

python_prepare_all() {
	# Prevent un-needed download during build
	sed -e "/^              'sphinx.ext.intersphinx',/d" -i doc/source/conf.py || die

	# https://github.com/pydata/pandas/issues/11299
	sed \
		-e 's:testOdArray:disable:g' \
		-i pandas/io/tests/test_json/test_ujson.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	# To build docs the need be located in $BUILD_DIR,
	# else PYTHONPATH points to unusable modules.
	if use doc; then
		cd "${BUILD_DIR}"/lib || die
		cp -ar "${S}"/doc . && cd doc || die
		LANG=C PYTHONPATH=. "${EPYTHON}" make.py html || die
	fi
}

python_test() {
	local test_pandas='not network and not disabled'
	[[ -n "${FAST_PANDAS}" ]] && test_pandas+=' and not slow'
	pushd  "${BUILD_DIR}"/lib > /dev/null
	VIRTUALX_COMMAND="nosetests"
	PYTHONPATH=. MPLCONFIGDIR=. \
		virtualmake --verbosity=3 -A "${test_pandas}" pandas
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
	local x
	elog "Please install"
	for x in ${EXTRA_DEPEND}; do
		optfeature "additional functionality" "${x%%[*}"
	done
}
