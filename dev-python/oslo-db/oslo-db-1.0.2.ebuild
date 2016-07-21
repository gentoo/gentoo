# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="OpenStack Common DB Code"
HOMEPAGE="https://launchpad.net/oslo"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.db/oslo.db-${PV}.tar.gz"
S="${WORKDIR}/oslo.db-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sqlite mysql postgres"
REQUIRED_USE="|| ( mysql postgres sqlite )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/alembic-0.6.4[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-0.3.0[${PYTHON_USEDEP}]
	sqlite? (
		|| (
			(
				>=dev-python/sqlalchemy-0.8.4[sqlite,${PYTHON_USEDEP}]
				<=dev-python/sqlalchemy-0.8.99[sqlite,${PYTHON_USEDEP}]
			)
			(
				>=dev-python/sqlalchemy-0.9.7[sqlite,${PYTHON_USEDEP}]
				<=dev-python/sqlalchemy-0.9.99[sqlite,${PYTHON_USEDEP}]
			)
		)
	)
	mysql? (
		dev-python/mysql-python
		|| (
			(
				>=dev-python/sqlalchemy-0.8.4[${PYTHON_USEDEP}]
				<=dev-python/sqlalchemy-0.8.99[${PYTHON_USEDEP}]
			)
			(
				>=dev-python/sqlalchemy-0.9.7[${PYTHON_USEDEP}]
				<=dev-python/sqlalchemy-0.9.99[${PYTHON_USEDEP}]
			)
		)
	)
	postgres? (
		dev-python/psycopg:2
		|| (
			(
				>=dev-python/sqlalchemy-0.8.4[${PYTHON_USEDEP}]
				<=dev-python/sqlalchemy-0.8.99[${PYTHON_USEDEP}]
			)
			(
				>=dev-python/sqlalchemy-0.9.7[${PYTHON_USEDEP}]
				<=dev-python/sqlalchemy-0.9.99[${PYTHON_USEDEP}]
			)
		)
	)
	>=dev-python/sqlalchemy-migrate-0.9.1[${PYTHON_USEDEP}]
	!~dev-python/sqlalchemy-migrate-0.9.2[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.0.0[${PYTHON_USEDEP}]
"
