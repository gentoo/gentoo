# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6..9} )

inherit distutils-r1

MY_PN="Flask-SQLAlchemy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SQLAlchemy support for Flask applications"
HOMEPAGE="https://pypi.org/project/Flask-SQLAlchemy/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/flask-0.10[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.8.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/pallets-sphinx-themes \
	dev-python/sphinx-issues
