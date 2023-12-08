# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="A client for the OpenStack APIs"
HOMEPAGE="
	https://opendev.org/openstack/python-openstackclient/
	https://github.com/openstack/python-openstackclient/
	https://pypi.org/project/python-openstackclient/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/cliff-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.7[${PYTHON_USEDEP}]
	>=dev-python/openstacksdk-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/osc-lib-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.22.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-18.1.0[${PYTHON_USEDEP}]
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
	local PATCHES=(
		# backport from master
		"${FILESDIR}/${P}-test.patch"
	)

	# Depends on specific runner
	sed -e 's/test_command_has_logger/_&/' -i openstackclient/tests/unit/common/test_command.py || die

	distutils-r1_src_prepare
}

python_test() {
	# functional tests require cloud instance access
	eunittest -b openstackclient/tests/unit
}
