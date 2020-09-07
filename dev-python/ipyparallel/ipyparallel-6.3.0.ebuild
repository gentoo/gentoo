# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 optfeature

DESCRIPTION="Interactive Parallel Computing with IPython"
HOMEPAGE="https://ipyparallel.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86 ~amd64-linux ~x86-linux"
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
BDEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/ipython[test]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
	"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

src_prepare() {
	# TODO: investigate
	sed -e 's:test_unicode:_&:' \
		-e 's:test_temp_flags:_&:' \
		-i ipyparallel/tests/test_view.py || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "Jupyter Notebook integration" dev-python/notebook
}
