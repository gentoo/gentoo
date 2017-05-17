# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy )

inherit distutils-r1

MY_PN="Flask-WhooshAlchemy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Whoosh extension to Flask/SQLAlchemy"
HOMEPAGE="https://github.com/gyllstromk/Flask-WhooshAlchemy https://pypi.python.org/pypi/Flask-WhooshAlchemy"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# TODO: figure out how to make it happy about the newer whoosh
# (i.e. if it's broken test or broken package)
RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	=dev-python/whoosh-2.6.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/flask-testing[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# unbind dependencies from specific versions
	sed -i -e 's/==.*$//' requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	# esetup.py test -- test module decl is broken
	"${PYTHON}" test/test_all.py || die "Tests fail with ${EPYTHON}"
}
