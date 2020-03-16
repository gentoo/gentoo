# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Jupyter protocol implementation and client libraries"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.4.0[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? ( dev-python/ipykernel[${PYTHON_USEDEP}]
			dev-python/ipython[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs \
	'dev-python/recommonmark' \
	'>=dev-python/sphinx-1.4.6'

python_test() {
	pytest -vv jupyter_client || die
}
