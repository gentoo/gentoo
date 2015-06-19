# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sqlalchemy-migrate/sqlalchemy-migrate-0.9.5.ebuild,v 1.1 2015/03/11 05:42:03 prometheanfire Exp $

EAPI=5
# py3 has a syntax errors. On testing it is underdone
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="SQLAlchemy Schema Migration Tools"
HOMEPAGE="http://code.google.com/p/sqlalchemy-migrate/ http://pypi.python.org/pypi/sqlalchemy-migrate"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8.0[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-0.7.8[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-0.9.5[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-0.9.99[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		>=dev-python/six-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/tempita-0.4[${PYTHON_USEDEP}]
		dev-python/python-sqlparse[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
