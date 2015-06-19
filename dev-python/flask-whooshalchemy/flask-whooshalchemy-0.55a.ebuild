# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask-whooshalchemy/flask-whooshalchemy-0.55a.ebuild,v 1.1 2013/09/11 09:25:21 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

RESTRICT="test"

inherit distutils-r1

MY_PN="Flask-WhooshAlchemy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Whoosh extension to Flask/SQLAlchemy"
HOMEPAGE="https://github.com/gyllstromk/Flask-WhooshAlchemy https://pypi.python.org/pypi/${MY_PN}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/whoosh[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/flask-testing[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}
