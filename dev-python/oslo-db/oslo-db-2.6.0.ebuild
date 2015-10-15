# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

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
	>=dev-python/pbr-1.6.0[${PYTHON_USEDEP}]
	<dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/alembic-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-2.0.0[${PYTHON_USEDEP}]
	sqlite? (
		|| (
			>=dev-python/sqlalchemy-0.9.9[sqlite,${PYTHON_USEDEP}]
			<dev-python/sqlalchemy-1.1.0[sqlite,${PYTHON_USEDEP}]
		)
	)
	mysql? (
		dev-python/mysql-python
		|| (
			>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
			<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
		)
	)
	postgres? (
		dev-python/psycopg:2
		|| (
			>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
			<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
		)
	)
	>=dev-python/sqlalchemy-migrate-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
	>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
"
