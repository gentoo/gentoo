# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

MY_PN="Flask-Migrate"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SQLAlchemy database migrations for Flask applications using Alembic"
HOMEPAGE="https://pypi.python.org/pypi/Flask-Migrate"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/flask-0.9[${PYTHON_USEDEP}]
	>=dev-python/alembic-0.6[${PYTHON_USEDEP}]
	>=dev-python/flask-sqlalchemy-1.0[${PYTHON_USEDEP}]
	>=dev-python/flask-script-0.6[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests -v || die "Testing failed with ${EPYTHON}"
}
