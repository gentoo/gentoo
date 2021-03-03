# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Highly concurrent networking library"
HOMEPAGE="https://pypi.org/project/eventlet/ https://github.com/eventlet/eventlet/"
SRC_URI="mirror://pypi/e/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="doc examples"

RDEPEND="
	>=dev-python/dnspython-1.15.0[${PYTHON_USEDEP}]
	<dev-python/dnspython-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3[${PYTHON_USEDEP}]
	>=dev-python/monotonic-1.4[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"
BDEPEND="
	doc? ( >=dev-python/python-docs-2.7.6-r1:2.7 )
	test? (
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.25.1-tests.patch"
	"${FILESDIR}/${PN}-0.30.0-tests-socket.patch"
)

distutils_enable_sphinx doc
distutils_enable_tests nose

python_prepare_all() {
	if use doc; then
		local PYTHON_DOC_ATOM=$(best_version -b dev-python/python-docs:2.7)
		local PYTHON_DOC_VERSION="${PYTHON_DOC_ATOM#dev-python/python-docs-}"
		local PYTHON_DOC="/usr/share/doc/python-docs-${PYTHON_DOC_VERSION}/html"
		local PYTHON_DOC_INVENTORY="${PYTHON_DOC}/objects.inv"
		sed -i "s|'https://docs.python.org/': None|'${PYTHON_DOC}': '${PYTHON_DOC_INVENTORY}'|" doc/conf.py || die
	fi

	# Prevent file collisions from teestsuite
	sed -e "s:'tests', :'tests', 'tests.*', :" -i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	unset PYTHONPATH
	export TMPDIR="${T}"
	nosetests -v || die
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}
