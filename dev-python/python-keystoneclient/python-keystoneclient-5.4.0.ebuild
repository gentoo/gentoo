# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1,
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Client Library for OpenStack Identity"
HOMEPAGE="
	https://opendev.org/openstack/python-keystoneclient/
	https://github.com/openstack/python-keystoneclient/
	https://pypi.org/project/python-keystoneclient/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth1-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>dev-python/oslo-serialization-2.19.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.5.0[${PYTHON_USEDEP}]
		>=dev-python/oauthlib-0.6.2[${PYTHON_USEDEP}]
		>=dev-python/os-client-config-1.28.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/tempest-17.1.0[${PYTHON_USEDEP}]
		>=dev-python/testresources-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	# functional tests require cloud instance access
	eunittest keystoneclient/tests/unit
}
