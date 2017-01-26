# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Interactive Parallel Computing with IPython"
HOMEPAGE="http://ipython.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"

RDEPEND="
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.4.0[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	!<dev-python/ipython-4.0.0[smp]
	>=dev-python/ipython-4.0.0[${PYTHON_USEDEP}]
	dev-python/notebook[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
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
	use doc && emake -C docs html
}

python_test() {
	iptest ipyparallel.tests -- -vsx || die
}

python_install_all() {
	use doc && HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
