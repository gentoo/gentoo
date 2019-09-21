# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_5 )

inherit distutils-r1

DESCRIPTION="A library for glance"
HOMEPAGE="https://github.com/openstack/glance_store"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
"
RDEPEND="
	${CDEPEND}
	>=dev-python/oslo-config-4.0.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-4.3.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-i18n-3.15.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-serialization-1.19.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.18.4[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.20.1[${PYTHON_USEDEP}]
	<dev-python/eventlet-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/jsonschema-2.5.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
"
