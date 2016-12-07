# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5)

inherit distutils-r1

DESCRIPTION="OpenStack Common DB Code"
HOMEPAGE="https://launchpad.net/oslo"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.db/oslo.db-${PV}.tar.gz"
S="${WORKDIR}/oslo.db-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+sqlite mysql postgres"
REQUIRED_USE="|| ( mysql postgres sqlite )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-1.6.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/alembic-0.8.4[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-3.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	sqlite? (
		|| (
			>=dev-python/sqlalchemy-1.0.10[sqlite,${PYTHON_USEDEP}]
			<dev-python/sqlalchemy-1.1.0[sqlite,${PYTHON_USEDEP}]
		)
	)
	mysql? (
		dev-python/mysql-python
		|| (
			>=dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
			<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
		)
	)
	postgres? (
		dev-python/psycopg:2
		|| (
			>=dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
			<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
		)
	)
	>=dev-python/sqlalchemy-migrate-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
"
