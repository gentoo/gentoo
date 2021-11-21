# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="A client for the OpenStack Glance API"
HOMEPAGE="https://github.com/openstack/python-glanceclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/keystoneauth-3.6.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-17.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/warlock-1.2.0[${PYTHON_USEDEP}]
	<dev-python/warlock-2[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.7.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	test? (
		dev-python/ddt[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/tempest[${PYTHON_USEDEP}]
		dev-python/testscenarios[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	# functional tests require cloud instance access
	eunittest -b glanceclient/tests/unit
}
