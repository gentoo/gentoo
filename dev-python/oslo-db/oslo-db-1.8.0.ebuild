# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/oslo-db/oslo-db-1.8.0.ebuild,v 1.1 2015/04/14 17:08:43 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="OpenStack Common DB Code"
HOMEPAGE="http://launchpad.net/oslo"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.db/oslo.db-${PV}.tar.gz"
S="${WORKDIR}/oslo.db-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sqlite mysql postgres"
REQUIRED_USE="|| ( mysql postgres sqlite )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.8.2[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/alembic-0.7.2[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-1.9.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.4.0[${PYTHON_USEDEP}]
	sqlite? (
		|| (
			>=dev-python/sqlalchemy-0.9.7[sqlite,${PYTHON_USEDEP}]
			<=dev-python/sqlalchemy-0.9.99[sqlite,${PYTHON_USEDEP}]
		)
	)
	mysql? (
		dev-python/mysql-python
		|| (
			>=dev-python/sqlalchemy-0.9.7[${PYTHON_USEDEP}]
			<=dev-python/sqlalchemy-0.9.99[${PYTHON_USEDEP}]
		)
	)
	postgres? (
		dev-python/psycopg:2
		|| (
			>=dev-python/sqlalchemy-0.9.7[${PYTHON_USEDEP}]
			<=dev-python/sqlalchemy-0.9.99[${PYTHON_USEDEP}]
		)
	)
	>=dev-python/sqlalchemy-migrate-0.9.5[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
	>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
"
