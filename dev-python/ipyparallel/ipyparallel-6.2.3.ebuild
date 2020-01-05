# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 eutils

DESCRIPTION="Interactive Parallel Computing with IPython"
HOMEPAGE="https://ipyparallel.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

# About tests and tornado
# Upstreams claims to work fine with tornado 5, and it's indeed possible to
# launch a cluster with tornado 5 installed, but tests definitely don't run with
# tornado 5 installed. Upstreams CI runs with tornado 4. This is why we limit
# ourselves to <tornado-5 when running tests.

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.4.0[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/ipython[test]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
		<www-servers/tornado-5
	)
	"

PATCHES=(
	"${FILESDIR}/${PN}-6.2.3-disable-broken-test.patch"
)

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_test() {
	pytest -vs ipyparallel/tests || die
}

pkg_postinst() {
	optfeature "Jupyter Notebook integration" dev-python/notebook
}
