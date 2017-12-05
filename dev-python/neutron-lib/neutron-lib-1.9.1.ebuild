# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="Neutron shared routines and utilities."
HOMEPAGE="https://github.com/openstack/neutron-lib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		${CDEPEND}"
RDEPEND="${CDEPEND}
	>=dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
	!~dev-python/sqlalchemy-1.1.5[${PYTHON_USEDEP}]
	!~dev-python/sqlalchemy-1.1.6[${PYTHON_USEDEP}]
	!~dev-python/sqlalchemy-1.1.7[${PYTHON_USEDEP}]
	!~dev-python/sqlalchemy-1.1.8[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-4.0.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-4.3.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-4.24.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-i18n-3.15.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.22.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-5.24.2[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-5.25.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-1.23.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.20.0[${PYTHON_USEDEP}]"
