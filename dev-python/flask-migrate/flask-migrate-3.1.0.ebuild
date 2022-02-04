# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_P="Flask-Migrate-${PV}"

DESCRIPTION="SQLAlchemy database migrations for Flask applications using Alembic"
HOMEPAGE="https://pypi.org/project/Flask-Migrate/"
SRC_URI="
	https://github.com/miguelgrinberg/Flask-Migrate/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/alembic-0.7[${PYTHON_USEDEP}]
	>=dev-python/flask-0.9[${PYTHON_USEDEP}]
	>=dev-python/flask-sqlalchemy-1.0[${PYTHON_USEDEP}]
"

distutils_enable_tests --install unittest
