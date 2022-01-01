# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="A client for the OpenStack APIs"
HOMEPAGE="https://github.com/openstack/python-openstackclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

RDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/cliff-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/openstacksdk-0.56.0[${PYTHON_USEDEP}]
	>=dev-python/osc-lib-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.22.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-17.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-2.0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/tempest-17.1.0[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/ddt-1.0.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	# Depends on specific runner
	sed -e 's/test_command_has_logger/_&/' -i openstackclient/tests/unit/common/test_command.py || die

	distutils-r1_src_prepare
}

python_test() {
	# functional tests require cloud instance access
	eunittest -b openstackclient/tests/unit
}
