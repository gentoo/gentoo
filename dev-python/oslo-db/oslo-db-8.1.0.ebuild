# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

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

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
"
RDEPEND="
	${CDEPEND}
	>=dev-python/alembic-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	sqlite? (
		>=dev-python/sqlalchemy-1.2.0[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		>=dev-python/pymysql-0.7.6[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.2.0[sqlite,${PYTHON_USEDEP}]
	)
	postgres? (
		>=dev-python/psycopg-2.7[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.2.0[sqlite,${PYTHON_USEDEP}]
	)
	>=dev-python/sqlalchemy-migrate-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^testresources/d' requirements.txt || die
	sed -i '/^testscenarios/d' requirements.txt || die
	distutils-r1_python_prepare_all
}
