# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="OpenStack Cinder brick library for managing local volume attaches"
HOMEPAGE="https://github.com/openstack/os-vif"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/os_vif-${PV}.tar.gz"
S="${WORKDIR}/os_vif-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.30.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-privsep-1.23.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-versionedobjects-1.28.0[${PYTHON_USEDEP}]
	>=dev-python/ovsdbapp-0.12.1[${PYTHON_USEDEP}]
	>=dev-python/pyroute2-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.19.0[${PYTHON_USEDEP}]
"
