# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Interactive Parallel Computing with IPython"
HOMEPAGE="https://ipyparallel.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	!<dev-python/ipython-4.0.0[smp,${PYTHON_USEDEP}]
	>=dev-python/ipython-4.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '<dev-python/ipython-6[${PYTHON_USEDEP}]' 'python2_7')
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/notebook[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.4.0[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	virtual/python-futures[${PYTHON_USEDEP}]
	>=dev-python/setuptools-18.5[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
	"

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
	iptest --coverage xml ipyparallel.tests -- -vsx || die
}
